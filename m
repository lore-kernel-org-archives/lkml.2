Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab1K0KTr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 05:19:47 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56351 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868Ab1K0KTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 05:19:46 -0500
X-Sasl-enc: JOWBQ/hwRB/DzIlxYbYDcSe27foN1LIgkX87eMUN+GAX 1322389181
Date: Sat, 26 Nov 2011 20:17:52 -0800
From: Greg KH <greg@kroah.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 02/11] TTY: Remove redundant spi driver bus initialization
Message-ID: <20111127041752.GA16415@kroah.com>
References: <1322148561-25138-1-git-send-email-lars@metafoo.de>
 <1322148561-25138-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322148561-25138-2-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 04:29:12PM +0100, Lars-Peter Clausen wrote:
> In ancient times it was necessary to manually initialize the bus field of an
> spi_driver to spi_bus_type. These days this is done in spi_driver_register(),
> so we can drop the manual assignment.
> 
> The patch was generated using the following coccinelle semantic patch:
> // <smpl>
> @@
> identifier _driver;
> @@
> struct spi_driver _driver = {
> 	.driver = {
> -		.bus = &spi_bus_type,
> 	},
> };
> // </smpl>
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Alan Cox <alan@linux.intel.com> (maintainer:SERIAL DRIVERS)
> Cc: linux-serial@vger.kernel.org (open list:SERIAL DRIVERS)

The () isn't needed, or nice, as I now need to edit this file by hand
and remove that text.  When applying 400+ patches in a single day, it
gets old fast...

thanks,

greg k-h
