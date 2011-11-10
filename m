Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693Ab1KJNks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:40:48 -0500
Received: from gate.crashing.org ([63.228.1.57]:55779 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab1KJNkr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:40:47 -0500
Subject: Re: [RFC PATCH 08/17] powerpc/e500: Remove conditional "lwsync" substitution
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1320883635-17194-9-git-send-email-Kyle.D.Moffett@boeing.com>
Date: Thu, 10 Nov 2011 07:40:04 -0600
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Baruch Siach <baruch@tkos.co.il>, Timur Tabi <B04825@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <3937191C-A735-4668-8E80-9FB4B35E2F63@kernel.crashing.org>
References: <4E42AB6F.1050900@freescale.com> <1320883635-17194-9-git-send-email-Kyle.D.Moffett@boeing.com>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 9, 2011, at 6:07 PM, Kyle Moffett wrote:

> As FreeScale e500 systems have different cacheline sizes from e500mc, it
> is basically impossible for the kernel to support both in a single
> system image at present.
> 
> Given that one is SPE-float and the other is classic-float, they are not
> generally userspace-compatible either.
> 
> This patch updates the conditional to depend on whether the system is
> actually targetting an "e500" or "e500mc" core and entirely removes the
> unused sync-to-lwsync-replacement on e500v1/e500v2 systems.
> 
> Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
> ---
> arch/powerpc/include/asm/synch.h |   16 ++++------------
> 1 files changed, 4 insertions(+), 12 deletions(-)

Nak, we can run an e500mc in a mode that is compatible with e500v1/v2.  I see no reason to change the support we have there.

- k