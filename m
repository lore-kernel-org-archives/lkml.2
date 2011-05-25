Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab1EYUpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:45:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56929 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756513Ab1EYUpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:45:33 -0400
Date: Wed, 25 May 2011 22:45:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] x86, UV: Reformat uv_mmrs.h - no code changes
Message-ID: <20110525204523.GA28397@elte.hu>
References: <20110512133308.GA17113@sgi.com>
 <20110513124029.GB3924@elte.hu>
 <20110525161634.GA13451@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525161634.GA13451@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jack Steiner <steiner@sgi.com> wrote:

> No code changes.  Reformat file to eliminate errors caught
> by checkpatch.pl
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>
> 
> ---
> V2 - this patch applies on top of "[PATCH] x86, UV: Support for SGI UV2 hub chip".
> 
> I fixed alignment of comments in the structure definitions. All checkpatch.pl
> ERRORS & WARNINGS are also fixed.
> 
> Some of the symbol names are still quite long. The file is based on post-processing
> of verilog definitions that are used for the node controller chip design. Although
> some symbol names are not what I would chose, I would like to maintain compatibility
> with the names used by the chip designers. We have a number of cross-reference
> utilities & having common names is important. Hope this is ok...

I looked at the resulting file and while it improved with this patch, 
it still has obvious problems with things like:

#define UVH_BAU_DATA_CONFIG_VECTOR_SHFT 0
#define UVH_BAU_DATA_CONFIG_VECTOR_MASK 0x00000000000000ffUL
#define UVH_BAU_DATA_CONFIG_DM_SHFT 8
#define UVH_BAU_DATA_CONFIG_DM_MASK 0x0000000000000700UL
#define UVH_BAU_DATA_CONFIG_DESTMODE_SHFT 11
#define UVH_BAU_DATA_CONFIG_DESTMODE_MASK 0x0000000000000800UL
#define UVH_BAU_DATA_CONFIG_STATUS_SHFT 12
#define UVH_BAU_DATA_CONFIG_STATUS_MASK 0x0000000000001000UL
#define UVH_BAU_DATA_CONFIG_P_SHFT 13
#define UVH_BAU_DATA_CONFIG_P_MASK 0x0000000000002000UL
#define UVH_BAU_DATA_CONFIG_T_SHFT 15
#define UVH_BAU_DATA_CONFIG_T_MASK 0x0000000000008000UL
#define UVH_BAU_DATA_CONFIG_M_SHFT 16
#define UVH_BAU_DATA_CONFIG_M_MASK 0x0000000000010000UL
#define UVH_BAU_DATA_CONFIG_APIC_ID_SHFT 32
#define UVH_BAU_DATA_CONFIG_APIC_ID_MASK 0xffffffff00000000UL

and the same mistake repeated all over again. Does this sequence 
really look visually good to you?

Check the enum declarations in include/linux/perf_event.h for 
example. Do you see the visual difference?

Btw., keeping the Verilog cross-reference compatibility is fine IMO.

Thanks,

	Ingo
