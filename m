Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab1CHQxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 11:53:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59605 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1CHQxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 11:53:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y6h/6XM1CeHQ8IfPwINJCTys9oFndCfzDpasTONIphzoBQjYE51IF6yM9wM2Te9pCf
         ovkpwLLbN/cnYBVqrkcJev/Gby98uJ+O7hoFrRkGR2uh/HOuB4tID1u4Jywwi27hAY4Y
         H9HRIGwWQogm82aWvIsWUrcD+YCLgVPaRAO+E=
Date: Tue, 8 Mar 2011 18:53:09 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, bskeggs@redhat.com
Subject: Re: 2.6.38-rc8: lockdep vs nouveau
Message-ID: <20110308165309.GA25650@p183.telecom.by>
References: <AANLkTimG-1nSZw3P5q7LQbGmQch3ibsMPQ_duhAjhtQH@mail.gmail.com>
 <20110308092254.GA4909@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110308092254.GA4909@p183.telecom.by>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 11:22:54AM +0200, Alexey Dobriyan wrote:
> [drm] No driver support for vblank timestamp query.
> 
> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 2.6.38-rc8 #9
> ---------------------------------------------------------
> kworker/0:1/0 just changed the state of lock:
>  (&(&dev_priv->context_switch_lock)->rlock){-.....}, at: [<ffffffff812a6727>] nouveau_irq_handler+0x57/0x150

And then, there is this:

	...
[12085.767490] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - VM: Trapped write at 00417c1400 status 0000cb20 channel 2 (0x00000906)
[12085.767493] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - Unknown fault at address 00417c1400
[12085.767496] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - e0c: 00000000, e18: 00000000, e1c: 00120000, e20: 00000011, e24: 0c030000
[12085.767503] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[12085.767507] [drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000906000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
	...
[19445.986827] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - VM: Trapped write at 00417c2400 status 0000cb20 channel 2 (0x00000906)
[19445.986835] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - Unknown fault at address 0040b16300
[19445.986841] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - e0c: 00000000, e18: 00000000, e1c: 000c0000, e20: 00000011, e24: 0c030000
[19445.986851] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[19445.986860] [drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000906000) subc 2 class 0x502d mthd 0x0860 data 0x6e51504f
[19458.826528] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - VM: Trapped write at 0040b17b00 status 0000cb20 channel 2 (0x00000906)
[19458.826535] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - Unknown fault at address 0041a61300
[19458.826542] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - e0c: 00000000, e18: 00000000, e1c: 000c0000, e20: 00000011, e24: 0c030000
[19458.826552] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[19458.826561] [drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000906000) subc 2 class 0x502d mthd 0x0860 data 0x6e51504f
	...
[26658.316541] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - VM: Trapped write at 0041a62300 status 0000cb20 channel 2 (0x00000906)
[26658.316545] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - Unknown fault at address 0041cfc300
[26658.316548] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - e0c: 00000000, e18: 00000000, e1c: 000c0020, e20: 00000011, e24: 0c030000
[26658.316555] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[26658.316559] [drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000906000) subc 2 class 0x502d mthd 0x0860 data 0x6b4e4d4d
[27184.011732] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - VM: Trapped write at 0041bf4300 status 0000cb20 channel 2 (0x00000906)
[27184.011735] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - Unknown fault at address 0041bf4300
[27184.011738] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - e0c: 00000000, e18: 00000000, e1c: 000c0020, e20: 00000011, e24: 0c030000
[27184.011745] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[27184.011749] [drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000906000) subc 2 class 0x502d mthd 0x0860 data 0x6b4e4d4d
[27184.011767] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - VM: Trapped write at 0041bf5400 status 0000cb20 channel 2 (0x00000906)
[27184.011769] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - Unknown fault at address 0041bf5400
[27184.011772] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - e0c: 00000000, e18: 00000000, e1c: 00100046, e20: 00000011, e24: 0c030000
[27184.011779] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[27184.011782] [drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000906000) subc 2 class 0x502d mthd 0x0860 data 0x61474646
[27184.011800] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - VM: Trapped write at 0041bf5c00 status 0000cb20 channel 2 (0x00000906)
[27184.011802] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - Unknown fault at address 0041bf5c00
[27184.011804] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - e0c: 00000000, e18: 00000000, e1c: 0012005e, e20: 00000011, e24: 0c030000
[27184.011811] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[27184.011814] [drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000906000) subc 2 class 0x502d mthd 0x0860 data 0x09060606
[27184.011835] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - VM: Trapped write at 0041bf6d00 status 0000cb20 channel 2 (0x00000906)
[27184.011836] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - Unknown fault at address 0041bf6d00
[27184.011838] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - e0c: 00000000, e18: 00000000, e1c: 00140076, e20: 00000011, e24: 0c030000
[27184.011845] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[27184.011848] [drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000906000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[27184.011865] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - VM: Trapped write at 0041bf7500 status 0000cb20 channel 2 (0x00000906)
[27184.011867] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - Unknown fault at address 0041bf7500
[27184.011869] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - e0c: 00000000, e18: 00000000, e1c: 0016008e, e20: 00000011, e24: 0c030000
[27184.011876] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[27184.011879] [drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000906000) subc 2 class 0x502d mthd 0x060c data 0x0000000a
[27236.139499] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - VM: Trapped write at 0041cc0300 status 0000cb20 channel 2 (0x00000906)
[27236.139503] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - Unknown fault at address 0041cc0300
[27236.139505] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - e0c: 00000000, e18: 00000000, e1c: 000e0020, e20: 00000011, e24: 0c030000
[27236.139513] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[27236.139516] [drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000906000) subc 2 class 0x502d mthd 0x0860 data 0x684c4b4b
[27236.139535] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - VM: Trapped write at 0041cc4400 status 0000cb20 channel 2 (0x00000906)
[27236.139537] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - Unknown fault at address 0041cc4400
[27236.139539] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - e0c: 00000000, e18: 00000000, e1c: 001000a0, e20: 00000011, e24: 0c030000
[27236.139546] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[27236.139549] [drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000906000) subc 2 class 0x502d mthd 0x0860 data 0x09060606
[27259.300269] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - VM: Trapped write at 00418c5400 status 0000cb20 channel 2 (0x00000906)
[27259.300276] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - Unknown fault at address 00418c5400
[27259.300283] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - e0c: 00000000, e18: 00000000, e1c: 00120020, e20: 00000011, e24: 0c030000
[27259.300293] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[27259.300301] [drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000906000) subc 2 class 0x502d mthd 0x0860 data 0x00000000
[27259.300324] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TPDMA - VM: Trapped write at 00418c5500 status 0000cb20 channel 2 (0x00000906)
[27259.300329] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - Unknown fault at address 00418c5500
[27259.300335] [drm] nouveau 0000:01:00.0: PGRAPH_TRAP_TPDMA_2D - TP 0 - e0c: 00000000, e18: 00000000, e1c: 00160020, e20: 00000011, e24: 0c030000
[27259.300345] [drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[27259.300352] [drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000906000) subc 2 class 0x502d mthd 0x060c data 0x0000000a
