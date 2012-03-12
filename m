Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab2CLFb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 01:31:29 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:36842 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2CLFb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 01:31:26 -0400
X-Auth-Info: O3Q9oYIBKYCwEW/mp5HJHQc3cWtSUsi5WIDC3jjhhWI=
To: Mai La <mla@apm.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Tirumala R Marri <tmarri@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Michael Neuling <mikey@neuling.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, open-source-review@apm.com
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH 1/2] powerpc/44x: Fix PCI MSI support for Maui APM821xx SoC and Bluestone board
MIME-Version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8bit
In-reply-to: <1331524918-22515-1-git-send-email-mla@apm.com>
References: <1331524918-22515-1-git-send-email-mla@apm.com>
Comments: In-reply-to Mai La <mla@apm.com>
   message dated "Mon, 12 Mar 2012 11:01:58 +0700."
Date: Mon, 12 Mar 2012 06:31:12 +0100
Message-Id: <20120312053112.B5643202BE9@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mai La,

In message <1331524918-22515-1-git-send-email-mla@apm.com> you wrote:
> This patch consists of:
> - Enable PCI MSI as default for Bluestone board
> - Change definition of number of MSI interrupt as it depends on SoC
> - Fix returning ENODEV as finding MSI node
> - Fix MSI physical high and low address
> - Keep MSI data logically
> 
> Signed-off-by: Mai La <mla@apm.com>

This is an updated version of your patch of March 09, right -
http://article.gmane.org/gmane.linux.kernel/1264255  ??

If so, you should mark ot as patch V2 in the Subject:, and add a
description of what you changed.

> -	SDR0_WRITE(sdr_addr, (u64)res.start >> 32);	 /*HIGH addr */
> -	SDR0_WRITE(sdr_addr + 1, res.start & 0xFFFFFFFF); /* Low addr */
> -
> +	mtdcri(SDR0, *sdr_addr, upper_32_bits(res.start));	/*HIGH addr */
> +	mtdcri(SDR0, *sdr_addr + 1, lower_32_bits(res.start));	/* Low addr */
...
> +	msi->msi_addr_hi = (u32)(msi_phys >> 32);
> +	msi->msi_addr_lo = (u32)(msi_phys & 0xffffffff);

Is there any reason for not using upper_32_bits() / lower_32_bits()
consistently?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Real computer scientists despise the idea of actual  hardware.  Hard-
ware has limitations, software doesn't. It's a real shame that Turing
machines are so poor at I/O.
