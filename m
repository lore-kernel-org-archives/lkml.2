Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab2ETFX1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 01:23:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52753 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab2ETFXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 01:23:25 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] MIPS: OCTEON: Add register definitions for SPI host hardware.
To: David Daney <ddaney.cavm@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-doc@vger.kernel.org, David Daney <david.daney@cavium.com>
In-Reply-To: <1336772086-17248-2-git-send-email-ddaney.cavm@gmail.com>
References: <1336772086-17248-1-git-send-email-ddaney.cavm@gmail.com> <1336772086-17248-2-git-send-email-ddaney.cavm@gmail.com>
Date: Sat, 19 May 2012 23:23:23 -0600
Message-Id: <20120520052323.1CDE53E03B8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012 14:34:45 -0700, David Daney <ddaney.cavm@gmail.com> wrote:
> From: David Daney <david.daney@cavium.com>
> 
> Needed by SPI driver.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  arch/mips/include/asm/octeon/cvmx-mpi-defs.h |  328 ++++++++++++++++++++++++++
>  1 files changed, 328 insertions(+), 0 deletions(-)
>  create mode 100644 arch/mips/include/asm/octeon/cvmx-mpi-defs.h
> 
> diff --git a/arch/mips/include/asm/octeon/cvmx-mpi-defs.h b/arch/mips/include/asm/octeon/cvmx-mpi-defs.h
> new file mode 100644
> index 0000000..4615b10
> --- /dev/null
> +++ b/arch/mips/include/asm/octeon/cvmx-mpi-defs.h
> @@ -0,0 +1,328 @@
> +/***********************license start***************
> + * Author: Cavium Networks
> + *
> + * Contact: support@caviumnetworks.com
> + * This file is part of the OCTEON SDK
> + *
> + * Copyright (c) 2003-2012 Cavium Networks
> + *
> + * This file is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License, Version 2, as
> + * published by the Free Software Foundation.
> + *
> + * This file is distributed in the hope that it will be useful, but
> + * AS-IS and WITHOUT ANY WARRANTY; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE, TITLE, or
> + * NONINFRINGEMENT.  See the GNU General Public License for more
> + * details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this file; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
> + * or visit http://www.gnu.org/licenses/.
> + *
> + * This file may also be available under a different license from Cavium.
> + * Contact Cavium Networks for more information
> + ***********************license end**************************************/
> +
> +#ifndef __CVMX_MPI_DEFS_H__
> +#define __CVMX_MPI_DEFS_H__
> +
> +#define CVMX_MPI_CFG (CVMX_ADD_IO_SEG(0x0001070000001000ull))
> +#define CVMX_MPI_DATX(offset) (CVMX_ADD_IO_SEG(0x0001070000001080ull) + ((offset) & 15) * 8)
> +#define CVMX_MPI_STS (CVMX_ADD_IO_SEG(0x0001070000001008ull))
> +#define CVMX_MPI_TX (CVMX_ADD_IO_SEG(0x0001070000001010ull))
> +
> +union cvmx_mpi_cfg {
> +	uint64_t u64;
> +	struct cvmx_mpi_cfg_s {
> +#ifdef __BIG_ENDIAN_BITFIELD
> +		uint64_t reserved_29_63:35;
> +		uint64_t clkdiv:13;
> +		uint64_t csena3:1;
> +		uint64_t csena2:1;
> +		uint64_t csena1:1;
> +		uint64_t csena0:1;
> +		uint64_t cslate:1;
> +		uint64_t tritx:1;
> +		uint64_t idleclks:2;
> +		uint64_t cshi:1;
> +		uint64_t csena:1;
> +		uint64_t int_ena:1;
> +		uint64_t lsbfirst:1;
> +		uint64_t wireor:1;
> +		uint64_t clk_cont:1;
> +		uint64_t idlelo:1;
> +		uint64_t enable:1;
> +#else
> +		uint64_t enable:1;
> +		uint64_t idlelo:1;
> +		uint64_t clk_cont:1;
> +		uint64_t wireor:1;
> +		uint64_t lsbfirst:1;
> +		uint64_t int_ena:1;
> +		uint64_t csena:1;
> +		uint64_t cshi:1;
> +		uint64_t idleclks:2;
> +		uint64_t tritx:1;
> +		uint64_t cslate:1;
> +		uint64_t csena0:1;
> +		uint64_t csena1:1;
> +		uint64_t csena2:1;
> +		uint64_t csena3:1;
> +		uint64_t clkdiv:13;
> +		uint64_t reserved_29_63:35;
> +#endif
> +	} s;

:-/  I'm not a fan of bitfields for register access. I'd much rather
have macros the various bit positions; but given that this live under
arch/mips I can't really say much and you can add my acked-by if you
need to.

