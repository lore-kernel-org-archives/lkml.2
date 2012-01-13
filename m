Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851Ab2AMTDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 14:03:20 -0500
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:48651
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753643Ab2AMTDS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 14:03:18 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q0DJ35ST007392
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core merge for 3.3
In-Reply-To: <CAPXgP120MoEUK9vSiELx4nzkL9X3w=YBgXGs3Q-VPm-4ZjgvZQ@mail.gmail.com>
	(Kay Sievers's message of "Fri, 13 Jan 2012 02:39:27 +0100")
References: <20120106201126.GA7239@kroah.com>
	<CA+55aFzH1cqoxr5RR8yqPdjf4XphKHk9YmcDozPn_z7Aq3nDcg@mail.gmail.com>
	<CAPXgP120MoEUK9vSiELx4nzkL9X3w=YBgXGs3Q-VPm-4ZjgvZQ@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Fri, 13 Jan 2012 20:03:04 +0100
Message-ID: <gid3ane87r.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Fri, 13 Jan 2012 20:03:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

> On Fri, Jan 13, 2012 at 02:11, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Hmm. I think this is the cause of one of the suspend/resume problems I'm seeing:
>>
>>   Device 'machinecheck3' does not have a releae() function, it is
>> broken and must be fixed
>>
>> that's the WARN_ON() in drivers/base/core.c (line 192), and it comes
>> from disable_nonboot_cpus() doing the whole device_unregister() thing.
>>
>> Afaik, it's arch/x86/kernel/cpu/mcheck/mce.c.
>
> I guess this kind of warning just did not exist for the old sysdev
> devices. The 'machinecheck' devices are DEFINE_PER_CPU(struct device,
> mce_device) devices, so we will probably just add a dummy release
> function, which might not fix the problem you are seeing.
>
> Maybe you can check if the suspend problem goes away if you disable
> CONFIG_X86_MCE?

Hello,

three days ago I also reported about a suspend/resume problem and
disabling CONFIG_X86_MCE also helps on my machine, although I did not see
the above warning in my logs.

Dirk
