Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934723Ab1KJN7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:59:24 -0500
Received: from gate.crashing.org ([63.228.1.57]:41699 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934622Ab1KJN7V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:59:21 -0500
Subject: Re: [RFC PATCH 00/17] powerpc/e500: separate e500 from e500mc
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1320883399-15911-1-git-send-email-Kyle.D.Moffett@boeing.com>
Date: Thu, 10 Nov 2011 07:59:08 -0600
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Timur Tabi <B04825@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <FF2BF3F3-1158-4747-AEEC-03D6A7C462D9@kernel.crashing.org>
References: <4E42AB6F.1050900@freescale.com> <1320883399-15911-1-git-send-email-Kyle.D.Moffett@boeing.com>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 9, 2011, at 6:03 PM, Kyle Moffett wrote:

> Hello,
> 
> I saw Baruch Siach's patch:
>  powerpc: 85xx: separate e500 from e500mc
> 
> Unfortunately, that patch breaks the dependencies for the P5020DS
> platform and does not fix the underlying code which does not
> understand what the ambiguous "CONFIG_E500" means.
> 
> In order to fix the issue at the fundamental level, I created the
> following 17-patch series loosely based on Baruch's patch.
> 
> === High-Level Summary ===
> 
> The e500v1/v2 and e500mc/e5500 CPU families are not compatible with
> each other, yet they share the same "CONFIG_E500" Kconfig option.
> 
> The following patch series splits the 32-bit CPU support into two
> separate options: "CONFIG_FSL_E500_V1_V2" and "CONFIG_FSL_E500MC".
> Additionally, the 64-bit e5500 support is separated to its own config
> option ("CONFIG_FSL_E5500") which is automatically combined with
> either 32-bit e500MC or 64-bit Book-3E when the P5020DS board support
> is enabled.

So its clear from the community that there is confusion here and we need to clean this up.  I guess my attempt to support an kernel that ran on both E500v2 and E500mc isn't worth it.  However I don't want to completely remove the ability to do this.

Towards the cleanup I'd ask for a proposal on what exactly the CONFIG_ options we'd end up with would be and their meaning.

So today we have:

CONFIG_E500
CONFIG_PPC_E500MC

What do we want to move to?  I want to keep the builds such that we have only 2 classes:  e500V1/V2 and e500mc/e5500/e6500/.../eX500.  I see no reason to hyper-optimize e500mc vs e5500 vs e6500.

- k