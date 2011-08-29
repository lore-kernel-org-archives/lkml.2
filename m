Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1H2RV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:21:57 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:40606 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab1H2RVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:21:54 -0400
X-SpamScore: -5
X-BigFish: VPS-5(zz1432N98dKzz1202h1082kzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LQP9KC-02-2ZV-02
X-M-MSG: 
Date: Mon, 29 Aug 2011 19:21:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: Kyle Moffett <kyle@moffetthome.net>
CC: Alex Deucher <alexdeucher@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Pavel Ivanov <paivanof@gmail.com>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
Message-ID: <20110829172146.GE2025@gere.osrc.amd.com>
References: <CAG1a4rs53RwkSxBvRQ5MrUbm7KEnpuEjw2fhSnT_1vqVPQrqgA@mail.gmail.com>
 <1314435638.2321.12.camel@thor.local>
 <CAG1a4rukteF+NmmTEhYT5yOmUYfDcbZ5qsghai1wm3ndpeiesg@mail.gmail.com>
 <20110828053624.GC12851@liondog.tnic>
 <1314624021.2816.30.camel@twins>
 <20110829133808.GA2025@gere.osrc.amd.com>
 <CADnq5_Mppeym2spCqsRGYALQxWDjQ_yNuta4SYRH6Oocy=UjSg@mail.gmail.com>
 <CAGZ=bqKHvauaW8jdPR98d-X5dry_pADYHWH-OsJE_CXT9hdwVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAGZ=bqKHvauaW8jdPR98d-X5dry_pADYHWH-OsJE_CXT9hdwVw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 12:28:31PM -0400, Kyle Moffett wrote:
> No, Linus pushed back really hard last time this issue came up with
> something; a network driver if I recall correctly.

r8169 probably.

> The issue is that this happens *EVEN FOR MODULAR DRIVERS* during
> suspend/resume.  The firmware simply may not be available yet.
> 
> If the driver fundamentally cannot work without the firmware then it should
> bind to the device and wait until the first userspace action before requesting
> firmware.
> 
> Furthermore, the trend is generally to push the firmware OUT of the kernel
> binary to avoid any chance of license issues.  Even if the code is built-in
> it should not need built-in firmware.
> 
> The quickest fix is probably something like this:
> 
> config DRM_RADEON_FIRMWARE
>         tristate
>         default m if STANDALONE
>         default y
> 
> config DRM_RADEON
>         depends DRM_RADEON_FIRMWARE
> 
> That should prevent somebody from building the radeon driver into the
> kernel unless they manually indicate that they have the extra firmware.
> 
> Long-term, the driver should support modular firmware even when it's
> built-in to the kernel.

Yep, and drivers should be able to select the firmware they need without
users even needing to do anything about it except installing some
firmware-nonfree package or whatever.

Yeah, sounds much better than Kconfig actually aiding and abetting
firmware blobs in the kernel and users needing to do stuff.

Thanks.

-- 
Regards/Gruss,
Boris.

