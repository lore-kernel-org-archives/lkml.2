Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760615Ab0HLUsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 16:48:16 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36874 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962Ab0HLUsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 16:48:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6072"; a="50821668"
Date: Thu, 12 Aug 2010 13:48:11 -0700
From: David Brown <davidb@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Gregory Bean <gbean@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tsoni@qualcomm.com
Subject: Re: [RFC] the right way to use gpiolib hooks to automate power
 management?
Message-ID: <20100812204811.GA31315@huya.qualcomm.com>
References: <4C6423C1.9060509@codeaurora.org>
 <20100812182744.GC31982@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100812182744.GC31982@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 07:27:44PM +0100, Russell King - ARM Linux wrote:
> On Thu, Aug 12, 2010 at 09:39:29AM -0700, Gregory Bean wrote:
> > We have a written a software driver which reference-counts these gpio
> > lines (via a put()/get() api), putting them in their "high-power" active
> > configurations when they're in use, and dropping them down into a
> > high-impedance low-power setting when they're not.
> 
> Beware.  What you're suggesting can lead to an increase in power
> consumption rather than the reduction you're looking for.

That probably just got a little obscured, since I think Greg is more
concerned with the mechanism in software.  Our gpio's are generally
configured in "low power" to be high-impedance with a pull-up or
pull-down, depending on what it is hooked to.  They can be configured
in most of the ways that would make sense to do so.

It may be the case, though, that what this "low power" mode is might
need to also be configurable, since it likely depends on how the pin
is connected.

David
