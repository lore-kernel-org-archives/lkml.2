Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab1KJWmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 17:42:19 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59535 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1KJWmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 17:42:18 -0500
Date: Thu, 10 Nov 2011 22:42:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 02/16] ARM: pgtable: Fix compiler warning in
	ioremap.c introduced by nopud
Message-ID: <20111110224208.GT12913@n2100.arm.linux.org.uk>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com> <1320682618-1182-3-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320682618-1182-3-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 04:16:44PM +0000, Catalin Marinas wrote:
> With the arch/arm code conversion to pgtable-nopud.h, the section and
> supersection (un|re)map code triggers compiler warnings on UP systems.
> This is caused by pmd_offset() being given a pgd_t argument rather than
> a pud_t one. This patch makes the necessary conversion with the
> assumption that the pud is folded into the pgd. The page table setting
> code only loops over the pmd which is enough with the classic page
> tables. This code is not compiled when LPAE is enabled.

This should come before the nopud include, so that we don't introduce the
warnings in the first place.  The result should compile to the same code
with just this patch applied.
