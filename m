Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab1HLPtB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 11:49:01 -0400
Received: from netrider.rowland.org ([192.131.102.5]:35015 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753865Ab1HLPtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 11:49:00 -0400
Date: Fri, 12 Aug 2011 11:49:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Per Forlin <per.forlin@linaro.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linaro-dev@lists.linaro.org>, Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH v3] usb: gadget: storage_common: make FSG_NUM_BUFFERS
 variable size
In-Reply-To: <20110812092036.GM19467@legolas.emea.dhcp.ti.com>
Message-ID: <Pine.LNX.4.44L0.1108121147100.11936-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Aug 2011, Felipe Balbi wrote:

> On Mon, Aug 08, 2011 at 11:43:35PM +0200, Per Forlin wrote:
> > FSG_NUM_BUFFERS is set to 2 as default.
> > Usually 2 buffers are enough to establish a good buffering pipeline.
> > The number may be increased in order to compensate a for bursty VFS
> > behaviour.

> would it make sense to have this as a module parameter so we don't need
> to recompile the driver everytime we want to test the driver with a
> different number of buffers ??
> 
> Alan ?

People generally object to new module parameters unless there's a very 
good reason for them.

Since people won't want to experiment with changing this value unless
they're debugging anyway, we might make it a conditional module
parameter -- don't define the parameter unless CONFIG_USB_DEBUG is
enabled.

Alan Stern

