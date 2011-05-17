Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab1EQRvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:51:44 -0400
Received: from lo.gmane.org ([80.91.229.12]:53525 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722Ab1EQRvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:51:42 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: [PATCH 0/2] AMD ARAT fixes
Date: Tue, 17 May 2011 19:51:51 +0200
Message-ID: <4DD2B5B7.7010502@web.de>
References: <1305636919-31165-1-git-send-email-bp@amd64.org> <4DD2A496.8000407@web.de> <20110517165318.GH30053@aftab> <4DD2AEA7.4000108@web.de> <20110517174632.GA26422@gere.osrc.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
Cc: linux-kernel@vger.kernel.org, Nick Bowler <nbowler@elliptictech.com>,
        "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        "Rosenfeld, Hans" <Hans.Rosenfeld@amd.com>, X86-ML <x86@kernel.org>
X-Gmane-NNTP-Posting-Host: p5b3729aa.dip.t-dialin.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110402 Icedove/3.1.9
In-Reply-To: <20110517174632.GA26422@gere.osrc.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote, on 05/17/11 19:46:
> On Tue, May 17, 2011 at 07:21:43PM +0200, Jörg-Volker Peetz wrote:
>> Borislav Petkov wrote, on 05/17/11 18:53:
>>> On Tue, May 17, 2011 at 12:38:46PM -0400, Jörg-Volker Peetz wrote:
>>>> A kernel version 2.6.38.6 patched with your two patches modifying only
>>>> arch/x86/kernel/cpu/amd.c starts and runs without problems on the affected
>>>> system with a AMD Turion 64 processor. The system is pure x86_64 (Debian
>>>> Release: wheezy/sid) with gcc version 4.6.1 20110428 (prerelease) (Debian
>>>> 4.6.0-6) and GNU C Library (Debian EGLIBC 2.13-4) stable release version 2.13.
>>>
>>> Thanks for testing!
>>>
>>>> The only obvious difference I see is the message "using C1E aware idle routine"
>>>> in dmesg.
>>>
>>> That was your CPU, right:
>>>
>>> vendor_id       : AuthenticAMD
>>> cpu family      : 15
>>> model           : 36
>>> model name      : AMD Turion(tm) 64 Mobile Technology MT-40
>>> stepping        : 2
>>>
>>> ?
>> Yes, exactly.
>>
>>>
>>> If so, then the C1E idle line above shouldn't appear. Can you check that
>>> around line 698 in <arch/x86/kernel/cpu/amd.c> you have the following:
>>>
>>>  const int amd_erratum_400[] =
>>>        AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
>>>                            AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
>>>
>> The lines 683--685 in this file on my affected system are equal to the three
>> lines above (except for formatting).
> 
> Ok, let me confirm whether I understand you correctly: are you seeing
> the C1E line _with_ the two patches applied or without?
> 
> I'm fairly certain that with the patches, you shouldn't be seeing the
> line and the first patch is actually the fix for your machine where
> you don't have to press a button to continue, AFAICT and if I'm not
> completely on crack here.
> 
> Thanks.
> 

Yes, you are right, I saw it with the *unpatched* version. My mistake :-(
Sorry for the confusion and the trouble.
And thank you very much for caring.
-- 
Best regards,
Jörg-Volker.

