Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab1EKPwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:52:15 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:35561 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477Ab1EKPwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:52:12 -0400
Date: Wed, 11 May 2011 11:52:11 -0400
To: linux-kernel@vger.kernel.org
Cc: Mingkai Hu <Mingkai.hu@freescale.com>,
        Len Sorensen <lsorense@csclub.uwaterloo.ca>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: spi_fsl_spi broken when compiled as module by
 b36ece832512c1a0afa54ff0a56d63492a1caf08
Message-ID: <20110511155211.GA21349@caffeine.csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When code was refactored, spi_fsl_spi now depends on funfcionts in
spi-fsl_lib, but those are not exported symbols so when building as a
module the symbols are missing and the compile fails.

Adding these to spi_fsl_lib.c fixes the compile.

EXPORT_SYMBOL(mpc8xxx_spi_tx_buf_u32);
EXPORT_SYMBOL(mpc8xxx_spi_rx_buf_u32);
EXPORT_SYMBOL(mpc8xxx_spi_tx_buf_u16);
EXPORT_SYMBOL(mpc8xxx_spi_rx_buf_u16);
EXPORT_SYMBOL(mpc8xxx_spi_tx_buf_u8);
EXPORT_SYMBOL(mpc8xxx_spi_rx_buf_u8);
EXPORT_SYMBOL(mpc8xxx_spi_strmode);
EXPORT_SYMBOL(mpc8xxx_spi_probe);
EXPORT_SYMBOL(of_mpc8xxx_spi_probe);
EXPORT_SYMBOL(mpc8xxx_spi_remove);
EXPORT_SYMBOL(to_of_pinfo);

All releases since the refactoring was done would be affected.

-- 
Len Sorensen
