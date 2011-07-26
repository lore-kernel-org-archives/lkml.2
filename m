Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab1GZShj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:37:39 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:50202 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab1GZShf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:37:35 -0400
Date: Tue, 26 Jul 2011 20:37:21 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110726183721.GF32536@aftab>
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
 <4E2F0068.1080001@redhat.com>
 <20110726181304.GD32536@aftab>
 <4E2F0498.8050005@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E2F0498.8050005@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 02:16:56PM -0400, H. Peter Anvin wrote:
> >> Is it possible to derive the bit positions (and the need to mask them) 
> >> from the cpuid description of the cache topology and sizes?
> > 
> > As far as I understand your question, there's no need for deriving the
> > bit positions because they're not special. You just have to have bits
> > [14:12] the same across all processes - we simply opted for clearing
> > them in order to keep the patch as simple as possible. But we could just
> > as well hashed the library name and generated the bits from it and thus
> > keep them same per library (we have that version too, btw. :)).
> > 
> > FWIW, in both cases, the patch should fix even the virtualization
> > scenario with and without KSM.
> > 
> > Does that answer your question?
> > 
> 
> I think the question was the width (and position) for the mask... i.e.
> your [14:12] above which *is* magic.

Oh, that's easy: family 15h means bits [14:12] - those bits are used for
I$ index generation.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
