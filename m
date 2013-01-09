Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934088Ab3AIVL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:11:56 -0500
Received: from nm13-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.13]:26805
	"EHLO nm13-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933689Ab3AIVLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:11:54 -0500
X-Yahoo-Newman-Id: 558485.14952.bm@smtp106.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: yjozOMEVM1nANGsJVsvCvfHtiVLayOfr_sminvB82pgE5i5
 abkphdLhvck27Q5IuaC4gySSH8BBmhYyB6T_mA8bMefPK_4QUHzy9YCVK4JY
 2nebEtIb0rLTsI86O_lN4MCwRzo9KZNv_.Vf8Mr78WetWVl00oKdUlPcLF4.
 H_OPBXH8UG.JjjoJOrNiq3omVNEzsUnDjJxFjjZVzsTiHLjmPNzZ6l0bdCLc
 p9D6jBcmL3v_c60El2PNZKenF_NdwDmSzCpFBlWLbl7bclJCU8xne0ihThmG
 ie5mHVCgSRAJ8RrkDiiRPzH_PqnnL8nEPDo3.nkIph72ygAG0I9bIdTMmOOd
 5ozVCFLVJ.ymHEqfuoGET6KFnjVuOUgwPZfIA8O7H4fmvGtvkp5_xc0d54qr
 l6HTQMyuJHL85lxLOaZbhzeJ4vhzlIJVT1NTAA8ZPnLx.vOw9JG3llnvfh5H
 AgPSD
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50EDDD27.7030008@schaufler-ca.com>
Date: Wed, 09 Jan 2013 13:12:07 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jakub Jelinek <jakub@redhat.com>
CC: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        libc-alpha@sourceware.org, dwalsh@redhat.com, dmalcolm@redhat.com,
        sds@tycho.nsa.gov, segoon@openwall.com,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: Friendlier EPERM - Request for input
References: <1357747463.2593.28.camel@localhost> <1357760637.2593.55.camel@localhost> <50EDCFC0.3010401@schaufler-ca.com> <1357763560.1342.7.camel@localhost> <50EDD8D4.60003@schaufler-ca.com> <20130109205947.GE26036@sunsite.ms.mff.cuni.cz>
In-Reply-To: <20130109205947.GE26036@sunsite.ms.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/9/2013 12:59 PM, Jakub Jelinek wrote:
> On Wed, Jan 09, 2013 at 12:53:40PM -0800, Casey Schaufler wrote:
>> I'm suggesting that the string returned by get_extended_error_info()
>> ought to be the audit record the system call would generate, regardless
>> of whether the audit system would emit it or not.
> What system call would that info be for and would it be reset on next
> syscall that succeeded, or also failed?

It ought to be the same system call that generated the contents of errno.

>
> The thing is, various functions e.g. perform some syscall, save errno, do
> some other syscall, and if they decide that the first syscall should be what
> determines the whole function's errno, just restore errno from the saved
> value and return.

Whichever system call generated the content of errno. If that means
the functions that currently save away errno have to save away the
audit text, that's what it would have to do. Simple. Not necessarily
pleasant, but simple.


> Similarly, various functions just set errno upon
> detecting some error condition in userspace.

Then get_extended_error_info should return NULL.
Or, if the library code prefers, creates its own
audit record in valid audit record format.

> There is no 1:1 mapping between many libc library calls and syscalls.

Truth. I'm suggesting the get_extended_error_info behavior
match the errno behavior.

> So, when would it be safe to call this new get_extended_error_info function
> and how to determine to which syscall it was relevant?

Any time you could look at errno you should be able to get a matching
explanation from get_extended_error_info.


>
> 	Jakub
>

