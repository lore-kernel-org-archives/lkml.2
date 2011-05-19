Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426Ab1ESOWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 10:22:35 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37484 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932671Ab1ESOWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 10:22:33 -0400
X-Sasl-enc: hsJUXOGP5rOlZSnjK+YnAQ4l8uq7ShJZBOOTBKAJ+RJO 1305814952
Date: Thu, 19 May 2011 07:22:25 -0700
From: Greg KH <greg@kroah.com>
To: Timur Tabi <timur@freescale.com>
Cc: kumar.gala@freescale.com, benh@kernel.crashing.org, akpm@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-console@vger.kernel.org
Subject: Re: [PATCH 6/7] tty/powerpc: introduce the ePAPR embedded hypervisor
 byte channel driver
Message-ID: <20110519142225.GC21441@kroah.com>
References: <1305813272-31826-1-git-send-email-timur@freescale.com>
 <1305813272-31826-7-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305813272-31826-7-git-send-email-timur@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 08:54:31AM -0500, Timur Tabi wrote:
> +/*
> + * The udbg subsystem calls this function to display a single character.
> + * We convert CR to a CR/LF.
> + */
> +static void ehv_bc_udbg_putc(char c)
> +{
> +	if (c == '\n')
> +		byte_channel_spin_send('\r');
> +
> +	byte_channel_spin_send(c);
> +}

Why do this conversion in the driver?  Shouldn't that be something that
userspace worries about?

thanks,

greg k-h
