Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761568Ab0HFP6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 11:58:09 -0400
Received: from lo.gmane.org ([80.91.229.12]:42910 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761498Ab0HFP6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 11:58:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Raja R Harinath <harinath@hurrynot.org>
Subject: Re: [PATCH 3/3] lib: vsprintf: added a put_dec() test and benchmark tool
Date: Fri, 06 Aug 2010 21:27:09 +0530
Message-ID: <8762zn7mzu.fsf@hariville.hurrynot.org>
References: <f894e94adccb940ef904983fa039a28e12217f48.1280872240.git.mina86@mina86.com>
	<0543dae0f66ba8e0ce42ce3adf1fe31704eb240d.1280872240.git.mina86@mina86.com>
	<b3cd8c92d68f3ca7104be13841f1f66f7db9f7e1.1280872240.git.mina86@mina86.com>
	<201008060710.06304.vda.linux@googlemail.com>
	<op.vg0csju97p4s8u@pikus>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 117.192.153.106
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Cancel-Lock: sha1:dysdL8pr23Gw8E98tTiSK+o2nx4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Michał Nazarewicz <m.nazarewicz@samsung.com> writes:

> On Fri, 06 Aug 2010 07:10:06 +0200, Denys Vlasenko <vda.linux@googlemail.com> wrote:
>
>> On Friday 06 August 2010 00:38, Michal Nazarewicz wrote:
>>> This commit adds a test application for the put_dec() and
>>> family of functions that are used by the previous two commits.
>>>
>>> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
>>
>>> +put-dec-test: put-dec-test.c
>>> +	exec $(CC) $(CFLAGS) -o $@ $<
>>
>> (1) Why exec?
>
> Micro Makefile optimisation -- saves us a fork().

I don't think it's worth it.  The use of 'exec' will force make to
invoke the shell, while without the exec, make has an opportunity to
optimize out the shell invocation completely [1].  Forcing the use of a
shell to avoid a fork() sounds like a terrible trade-off.

- Hari

[1] See, for instance, construct_command_argv_internal() in

  http://cvs.savannah.gnu.org/viewvc/make/job.c?root=make&view=markup

