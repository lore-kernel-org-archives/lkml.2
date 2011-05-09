Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab1EIKd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 06:33:28 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58942 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab1EIKd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 06:33:26 -0400
Date: Mon, 9 May 2011 11:32:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v5 02/19] ARM: LPAE: add ISBs around MMU enabling code
Message-ID: <20110509103242.GQ27807@n2100.arm.linux.org.uk>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com> <1304859098-10760-3-git-send-email-catalin.marinas@arm.com> <20110508214101.GO27807@n2100.arm.linux.org.uk> <1304936539.7658.31.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304936539.7658.31.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 11:22:19AM +0100, Catalin Marinas wrote:
> Alternatively an exception return would do as well (like movs pc, lr)
> but I think we still add some code for setting up the SPSR.

That gives us a way out of both of these without introducing any CPU
specific code.  We can setup the SPSR before this block of code, and
call it with two movs pc, reg instructions which will provide the
necessary synchronization.

That sounds to me like an all-round better solution here.
