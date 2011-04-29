Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760856Ab1D2S4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:56:42 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44263 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab1D2S4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:56:40 -0400
Date: Fri, 29 Apr 2011 20:56:10 +0200
From: Borislav Petkov <bp@amd64.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>,
        =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <peetz@dynato-kyma.net>,
        Borislav Petkov <bp@alien8.de>,
        =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: Linux 2.6.38.4 : regression due to x86 AMD ARAT feature
Message-ID: <20110429185609.GG18746@aftab>
References: <20110421213926.GA19721@kroah.com>
 <4DB3DA0C.1050003@web.de>
 <20110424182041.GA19984@liondog.tnic>
 <4DB47211.90901@dynato-kyma.net>
 <EE335F95F28A664DB4A21289D2AA053BD1807651@SAUSEXMBP01.amd.com>
 <4DBB04C1.30003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DBB04C1.30003@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 02:34:41PM -0400, Jiri Slaby wrote:
> On 04/24/2011 09:44 PM, Ostrovsky, Boris wrote:
> > Borislav Petkov wrote, on 04/24/11 20:20:
> >> On Sun, Apr 24, 2011 at 10:06:36AM +0200, Jörg-Volker Peetz wrote:
> >>> With 2.6.38.4 the clock slows down and the affected laptop sometimes, e.g. for
> >>> the output of "ps axuw" to appear, needs an input from the keyboard or the
> >>> touchpad. Please find attached the kernel config file and the output of dmesg.
> >>>
> >>> Commenting out the the lines
> >>>
> >>>      if (c->x86 >= 0xf && !cpu_has_amd_erratum(amd_erratum_400))
> >>>              set_cpu_cap(c, X86_FEATURE_ARAT);
> >>>
> >>> in arch/x86/kernel/cpu/amd.c makes this laptop work as before with kernel
> >>> 2.6.38.3. I think these lines came with commit
> >>> d7b7f0c401303dd7eafcff11752fe74d3b75c766.
> 
> > It's an old family fh processor (CPUID 00020F42) that
> cpu_has_amd_erratum(amd_erratum_400) apparently hasn't picked up. Since
> all fh processors are affected by this erratum I'll replace "c->x86 >=
> 0xf" with "c->x86 > 0xf" (and probably fix erratum formula anyway).
> 
> Hi, what's the status of this please?
> 
> I don't see the fix neither in the -next tree.

Boris O will be coming up with a patch soon. We wanted to clarify the
details first.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
