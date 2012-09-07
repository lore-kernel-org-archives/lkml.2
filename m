Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab2IGB7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 21:59:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45315 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757532Ab2IGB7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 21:59:08 -0400
Date: Fri, 7 Sep 2012 09:59:01 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, rabin.vincent@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] regulator: disable supply regulator if it is enabled
 for boot-on
Message-ID: <20120907015900.GC6827@opensource.wolfsonmicro.com>
References: <1346682339-13322-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346682339-13322-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 07:55:39PM +0530, Laxman Dewangan wrote:

> +	/* If supply enabled during registrtaion then need to disable
> +	 * when full constraint enabled.
> +	 */
> +	unsigned int need_supply_disable:1;

I don't understand why we need this flag.  Shouldn't we just be making
the reference counts for the supplies correct and then have the
regulator disabled in the late initcall as a result of its refcount
falling to zero when the children are disabled?  I think what we need to
do here is always take a reference to the supply if the child is enabled
during boot, then in the initcall we can just disable the parent
regulator as normal.
