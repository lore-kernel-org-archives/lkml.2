Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab1CMBGx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 20:06:53 -0500
Received: from kroah.org ([198.145.64.141]:47456 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137Ab1CMBGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 20:06:52 -0500
Date: Sat, 12 Mar 2011 17:01:55 -0800
From: Greg KH <greg@kroah.com>
To: Andy Green <andy@warmcat.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        patches@linaro.org, Andy Green <andy.green@linaro.org>
Subject: Re: [RFC PATCH 3/4] PLATFORM: Introduce async platform_data attach
 api
Message-ID: <20110313010155.GA20396@kroah.com>
References: <20110312222633.27020.19543.stgit@otae.warmcat.com>
 <20110312223227.27020.83925.stgit@otae.warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110312223227.27020.83925.stgit@otae.warmcat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 12, 2011 at 10:32:27PM +0000, Andy Green wrote:
> This introduces a platform API so busses can allow platform_data to
> be attached to any struct device they create from probing in one step.
> 
> The function checks through the async platform_data map if one was
> previously registered, and checks the device's device path for itself
> and its parents against the mapped device path names.
> 
> If it sees a match, it attaches the associated platform_data and sets
> that map entry's device_path to NULL so no further time is spent trying
> to match it.

This _really_ should just use the device tree stuff, that is what it is
for, please don't duplicate it here in a not-as-flexible way.

Why wouldn't that work for you instead for this type of thing?

thanks,

greg k-h
