Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab1INPFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 11:05:05 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:49731 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab1INPFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 11:05:03 -0400
Date: Wed, 14 Sep 2011 17:04:52 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: "Maxin B. John" <maxin.john@gmail.com>
Cc: David Daney <david.daney@cavium.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Kevin Cernekee <cernekee@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mips: mm: tlbex.c: Fix compiler warnings
Message-ID: <20110914150452.GA12638@linux-mips.org>
References: <20110908220559.GA3040@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908220559.GA3040@maxin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 01:06:00AM +0300, Maxin B. John wrote:

>  CC      arch/mips/mm/tlbex.o
> cc1: warnings being treated as errors
> arch/mips/mm/tlbex.c: In function 'build_r3000_tlb_modify_handler':
> arch/mips/mm/tlbex.c:1769: error: 'wr.r1' is used uninitialized in this function
> arch/mips/mm/tlbex.c:1769: error: 'wr.r2' is used uninitialized in this function
> arch/mips/mm/tlbex.c:1769: error: 'wr.r3' is used uninitialized in this function
> make[2]: *** [arch/mips/mm/tlbex.o] Error 1
> make[1]: *** [arch/mips/mm] Error 2
> make: *** [arch/mips] Error 2

This was fixed by 949cb4ca0aa53e97ea5f524536593ad2d2946b73.  The real
fix to not pass the wr members to build_pte_modifiable() because they
just are not needed.

Thanks,

  Ralf
