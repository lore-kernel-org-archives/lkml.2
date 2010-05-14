Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab0ENH4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 03:56:55 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58952 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab0ENH4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 03:56:53 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>
References: <20100513075728.GF30110@core.coreip.homeip.net>
	<alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org>
	<20100513160117.GB22238@core.coreip.homeip.net>
	<alpine.LFD.2.00.1005130943460.3711@i5.linux-foundation.org>
	<20100513171639.GA23708@core.coreip.homeip.net>
	<alpine.LFD.2.00.1005131017070.3711@i5.linux-foundation.org>
	<20100513181002.GB23708@core.coreip.homeip.net>
	<alpine.LFD.2.00.1005131253310.3711@i5.linux-foundation.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 14 May 2010 00:56:45 -0700
In-Reply-To: <alpine.LFD.2.00.1005131253310.3711@i5.linux-foundation.org> (Linus Torvalds's message of "Thu\, 13 May 2010 12\:55\:38 -0700 \(PDT\)")
Message-ID: <m1aas2kjb6.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: torvalds@linux-foundation.org, hadess@hadess.net, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, dmitry.torokhov@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [git pull] Input updates for 2.6.34-rc6
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, 13 May 2010, Dmitry Torokhov wrote:
>> 
>> Is there an interface a driver can use to query the style of boot used?
>
> Maybe 'efi_enabled' will do. I haven't checked exact semantics of that 
> flag. And right now we don't even know if Bastien even uses EFI, or boots 
> a traditional kernel image through bootcamp.

efi_enabled is a guard on efi calls.  If it is true it tells you that
you can make runtime efi calls.  If it is false you can't use runtime
efi calls. efi_enabled does not tell you about the presence of efi
on a system.

efi_enabled is generally uninteresting because there is an agreement
that you should be able to all of the runtime work that matters with
acpi.

This is reinforced by the fact that efi comes in two different flavors
on x86 32bit and 64bit, and 64bit efi does not have a 32bit
compatibility layer (too many hard coded pointers in the interface).
You can't make 32bit efi calls from from a 64bit kernel or 64bit efi
calls from a 32bit kernel.

All of which means in the normal case pay attention to acpi.  That is
more likely to be correct and usable than EFI anything.

Eric
