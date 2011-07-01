Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab1GAWTC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 18:19:02 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:49531 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756640Ab1GAWTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 18:19:01 -0400
X-Sasl-enc: P7TNz4GxTTC7tFPtGUXVvG3VscCY6XmnQZUThxrP1ilt 1309558738
Date: Fri, 1 Jul 2011 15:09:00 -0700
From: Greg KH <greg@kroah.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v3 1/3] driver core: Add ability for arch code to setup
 pdev_archdata
Message-ID: <20110701220900.GA28971@kroah.com>
References: <1308744176-24491-1-git-send-email-galak@kernel.crashing.org>
 <1308828839-27349-1-git-send-email-galak@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308828839-27349-1-git-send-email-galak@kernel.crashing.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 06:33:57AM -0500, Kumar Gala wrote:
> On some architectures we need to setup pdev_archdata before we add the
> device.  Waiting til a bus_notifier is too late since we might need the
> pdev_archdata in the bus notifier.  One example is setting up of dma_mask
> pointers such that it can be used in a bus_notifier.
> 
> We add noop version of arch_setup_pdev_archdata() in
> <asm-generic/platform_device.h> and allow the arch code to override with
> access the full definitions of struct device, struct platform_device, and
> struct pdev_archdata.

Isn't there some way to use "weak" symbols to keep us from having to
create this .h file in every single arch and then if the arch wants to
define it, it does so?

That should make this patch simpler, right?

thanks,

greg k-h
