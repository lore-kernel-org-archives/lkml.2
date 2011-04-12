Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab1DLRb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:31:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:53827 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757068Ab1DLRb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:31:28 -0400
Date: Tue, 12 Apr 2011 10:13:43 -0700
From: Greg KH <gregkh@suse.de>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver-core: fix race between device_register and
 driver_register
Message-ID: <20110412171343.GA2745@suse.de>
References: <20110411141309.GA8924@suse.de>
 <alpine.LFD.2.02.1104111622490.1938@c4eb>
 <20110411144956.GA16610@suse.de>
 <alpine.LFD.2.02.1104111658560.1770@c4eb>
 <20110411151947.GA17913@suse.de>
 <alpine.LFD.2.02.1104111943590.2036@c4eb>
 <20110411175628.GA24301@suse.de>
 <alpine.LFD.2.02.1104121637450.2239@c4eb>
 <20110412160220.GA28483@suse.de>
 <alpine.LFD.2.02.1104121903170.2025@c4eb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1104121903170.2025@c4eb>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 07:05:37PM +0200, Sebastian Ott wrote:
> 
> When a device is registered to a bus it will be a) added to the list
> of devices of the bus and b) bind to a driver (if one matches). As a
> result of a driver being registered at this bus between a) and b) this
> device could already be bound to a driver. This leads to a warning
> and incorrect refcounting.
> To fix this add a check to device_attach to identify an already bound
> device.
> 
> Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>

Thanks, I'll queue this up for .40.

greg k-h
