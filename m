Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759120Ab2IES6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 14:58:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50571 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab2IES6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 14:58:01 -0400
Date: Wed, 5 Sep 2012 11:55:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Aneesh V <aneesh@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] memory: fix build when CONFIG_OF && !CONFIG_DDR
Message-ID: <20120905185527.GA9635@kroah.com>
References: <1346869763-11798-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346869763-11798-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 12:29:23PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Commit e6b42eb "memory: emif: add device tree support to emif driver"
> added drivers/memory/of_memory.c, which references tables defined in
> lib/jedec_ddr_data.c. of_memory.c is compiled when CONFIG_OF, whereas
> jedec_ddr_data.c is compiled when CONFIG_DDR. This breaks the build
> when CONFIG_OF is defined but not CONFIG_DDR:
> 
> drivers/built-in.o: In function `of_get_ddr_timings':
> drivers/memory/of_memory.c:138: undefined reference to `lpddr2_jedec_timings'
> drivers/built-in.o: In function `of_get_min_tck':
> drivers/memory/of_memory.c:62: undefined reference to `lpddr2_jedec_min_tck'
> make: *** [vmlinux] Error 1
> 
> To solve this, only compile of_memory.c when CONFIG_OF && CONFIG_DDR,
> otherwise, stub out the functions.

Ick, what a mess.  Thanks for the patch, I'll apply it, but surely there
is a "better" solution here?

thanks,

greg k-h
