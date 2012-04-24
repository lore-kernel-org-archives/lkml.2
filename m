Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab2DXKdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 06:33:44 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48564 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab2DXKdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 06:33:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org
References: <m1aa22rllb.fsf@fess.ebiederm.org> <4F96705C.5030901@suse.cz>
Date: Tue, 24 Apr 2012 03:37:46 -0700
In-Reply-To: <4F96705C.5030901@suse.cz> (Michal Marek's message of "Tue, 24
	Apr 2012 11:20:28 +0200")
Message-ID: <m11undpg91.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+z/G15z5o+MsoJGHLHK/c78bx1O6oEx7c=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0036]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Michal Marek <mmarek@suse.cz>
X-Spam-Relay-Country: **
Subject: Re: [PATCH] kbuld: Implement oldmodconfig
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Marek <mmarek@suse.cz> writes:

> Dne 24.4.2012 02:59, Eric W. Biederman napsal(a):
>> 
>> While verifying that my user namespace patches are as complete as I
>> expect them to be I came a came across the need to build kernel
>> configurations with a few choice settings disabled and everything else
>> enabled.  Adding a make oldmodconfig made generating those
>> configurations straight forward, as now I can set the options I care
>> about and the oldmodconfig can answering everything else for me in a
>> consistent way.
>
> Doesn't
>
> KCONFIG_ALLCONFIG=base.config make allmodconfig
>
> do the same thing? If not, the difference should be explained in the
> changelog.

The only difference apparently is that KCONFIG_ALLCONFIG... allmodconfig 
does not show up in the help and is rather unintuitively named so I
totally missed it's presence.

If I get ambitious I might fix the bug that KCONFIG_ALLCONFIG uses some
other working directory when reading a file than the directory that make
was run in.  Which is compounded by the fact that if KCONFIG_ALLCONFIG
can't find your file it treats it as if you had not specified the file
and does this all silently making it just about impossible to debug
without instrumenting up conf.c and confdata.c

So please feel free to drop my patch.

Eric
