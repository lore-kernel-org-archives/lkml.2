Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab2DAV2E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 17:28:04 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:51182 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab2DAV1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 17:27:54 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v5 06/27] irq_domain/powerpc: eliminate irq_map; use irq_alloc_desc() instead
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
	<1329383368-12122-7-git-send-email-grant.likely@secretlab.ca>
X-Yow: Darling, my ELBOW is FLYING over FRANKFURT, Germany..
Date: Sun, 01 Apr 2012 23:27:44 +0200
In-Reply-To: <1329383368-12122-7-git-send-email-grant.likely@secretlab.ca>
	(Grant Likely's message of "Thu, 16 Feb 2012 02:09:07 -0700")
Message-ID: <m2iphj3zxr.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.94 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely <grant.likely@secretlab.ca> writes:

> This patch drops the powerpc-specific irq_map table and replaces it with
> directly using the irq_alloc_desc()/irq_free_desc() interfaces for allocating
> and freeing irq_desc structures.

This breaks irqs on PowerMac G5.  I see lost irq errors from the sata
driver.

Note that the breakage only started after the series was merged into
mainline.  But when transplanted upon the parent of the merge this is
the commit that was blamed by bisect.  So something changed between
v3.3-rc3 and the merge of this series that broke it.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
