Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab2L0MQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 07:16:16 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:56143 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2L0MQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 07:16:13 -0500
Date: Thu, 27 Dec 2012 14:16:07 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-mips@linux-mips.org
Subject: Re: 3.8-rc1 build failure with MIPS/SPARSEMEM
Message-ID: <20121227121607.GA7097@blackmetal.musicnaut.iki.fi>
References: <20121222122757.GB6847@blackmetal.musicnaut.iki.fi>
 <20121226003434.GA27760@otc-wbsnb-06>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121226003434.GA27760@otc-wbsnb-06>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Dec 26, 2012 at 02:34:35AM +0200, Kirill A. Shutemov wrote:
> On MIPS if SPARSEMEM is enabled we've got this:
> 
> In file included from /home/kas/git/public/linux/arch/mips/include/asm/pgtable.h:552,
>                  from include/linux/mm.h:44,
>                  from arch/mips/kernel/asm-offsets.c:14:
> include/asm-generic/pgtable.h: In function ‘my_zero_pfn’:
> include/asm-generic/pgtable.h:466: error: implicit declaration of function ‘page_to_section’
> In file included from arch/mips/kernel/asm-offsets.c:14:
> include/linux/mm.h: At top level:
> include/linux/mm.h:738: error: conflicting types for ‘page_to_section’
> include/asm-generic/pgtable.h:466: note: previous implicit declaration of ‘page_to_section’ was here
> 
> Due header files inter-dependencies, the only way I see to fix it is
> convert my_zero_pfn() for __HAVE_COLOR_ZERO_PAGE to macros.
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

Thanks, this works.

Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>

A.
