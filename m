Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab1EQRqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:46:37 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:48021 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745Ab1EQRqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:46:36 -0400
Date: Tue, 17 May 2011 19:46:32 +0200
From: Borislav Petkov <bp@amd64.org>
To: =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>
Cc: linux-kernel@vger.kernel.org, Nick Bowler <nbowler@elliptictech.com>,
        "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        "Rosenfeld, Hans" <Hans.Rosenfeld@amd.com>, X86-ML <x86@kernel.org>
Subject: Re: [PATCH 0/2] AMD ARAT fixes
Message-ID: <20110517174632.GA26422@gere.osrc.amd.com>
References: <1305636919-31165-1-git-send-email-bp@amd64.org>
 <4DD2A496.8000407@web.de>
 <20110517165318.GH30053@aftab>
 <4DD2AEA7.4000108@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DD2AEA7.4000108@web.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 07:21:43PM +0200, Jörg-Volker Peetz wrote:
> Borislav Petkov wrote, on 05/17/11 18:53:
> > On Tue, May 17, 2011 at 12:38:46PM -0400, Jörg-Volker Peetz wrote:
> >> A kernel version 2.6.38.6 patched with your two patches modifying only
> >> arch/x86/kernel/cpu/amd.c starts and runs without problems on the affected
> >> system with a AMD Turion 64 processor. The system is pure x86_64 (Debian
> >> Release: wheezy/sid) with gcc version 4.6.1 20110428 (prerelease) (Debian
> >> 4.6.0-6) and GNU C Library (Debian EGLIBC 2.13-4) stable release version 2.13.
> > 
> > Thanks for testing!
> > 
> >> The only obvious difference I see is the message "using C1E aware idle routine"
> >> in dmesg.
> > 
> > That was your CPU, right:
> > 
> > vendor_id       : AuthenticAMD
> > cpu family      : 15
> > model           : 36
> > model name      : AMD Turion(tm) 64 Mobile Technology MT-40
> > stepping        : 2
> > 
> > ?
> Yes, exactly.
> 
> > 
> > If so, then the C1E idle line above shouldn't appear. Can you check that
> > around line 698 in <arch/x86/kernel/cpu/amd.c> you have the following:
> > 
> >  const int amd_erratum_400[] =
> >        AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
> >                            AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
> > 
> The lines 683--685 in this file on my affected system are equal to the three
> lines above (except for formatting).

Ok, let me confirm whether I understand you correctly: are you seeing
the C1E line _with_ the two patches applied or without?

I'm fairly certain that with the patches, you shouldn't be seeing the
line and the first patch is actually the fix for your machine where
you don't have to press a button to continue, AFAICT and if I'm not
completely on crack here.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
