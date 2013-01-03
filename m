Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab3ACXQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 18:16:49 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39706 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab3ACXQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 18:16:45 -0500
Date: Thu, 3 Jan 2013 23:11:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>
Subject: Re: [PATCH] arm: Export cache flush management symbols when
	!MULTI_CACHE
Message-ID: <20130103231132.GS2631@n2100.arm.linux.org.uk>
References: <1357252353-6200-1-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357252353-6200-1-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 12:32:33AM +0200, Pantelis Antoniou wrote:
> When compiling a kernel without CONFIG_MULTI_CACHE enabled the
> dma access functions end up not being exported. Fix it.

Actually, that's exactly how these are supposed to be: no driver should
_ever_ reference these symbols directly, they should all be done via
the DMA API, which internally uses these.  Therefore, none of these
should ever appear in a module.
