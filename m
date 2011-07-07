Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab1GGTaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:30:15 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34858 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab1GGTaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:30:14 -0400
Date: Thu, 7 Jul 2011 22:28:57 +0300
From: Dan Carpenter <error27@gmail.com>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Matt Mooney <mfm@muteddisk.com>,
        Max Vozeler <max@hinterhof.net>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        usbip-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] usbip: only dump valid port status
Message-ID: <20110707192857.GQ18655@shale.localdomain>
References: <4DF68151.4080109@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DF68151.4080109@freemail.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 11:29:53PM +0200, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> The wIndex parameter of vhci_hub_control() is always zero when the
> request type is GetHubDescriptor, see drivers/usb/core/hub.c::get_hub_descriptor()
> and Universal Serial Bus Specification revision 2.0 (April 27, 2000) Section
> 11.24.2.5 "Get Hub Descriptor". This means the variable rhport will not contain
> any useful index. Only use valid rhport values.
> 

Is it possible for wValue to be zero if the request type is is
SetPortFeature or ClearPortFeature?  If so then we should probably
add some more checks to handle that.

regards,
dan carpenter

