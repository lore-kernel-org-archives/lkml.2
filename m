Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab1BAKll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:41:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46648 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab1BAKlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:41:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=I27VieEc2wcxhlUt70MZcylSY5mtjnxpUwIp5R543e5YFG2d24z4Ov6Odl5wl0VmrW
         Cs1Zwa8Cc9+7OLXIo0VLYQnTDRva1VkAsEZ2fWNLRBlk8wnVLSg6stvJSHaLdcBkJgCl
         Z1Uw7+KDgNrKOSliKP9Ftt0AIKf5yvrzAzMdc=
Date: Tue, 1 Feb 2011 11:41:35 +0100
From: Tejun Heo <tj@kernel.org>
To: Ben Skeggs <skeggsb@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH UPDATED 08/32] drm/nouveau: use system_wq instead of
 dev_priv->wq
Message-ID: <20110201104135.GI14211@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-9-git-send-email-tj@kernel.org>
 <1294189627.2276.0.camel@nisroch>
 <1294190172.2276.2.camel@nisroch>
 <20110106172922.GA29580@mtj.dyndns.org>
 <20110126164918.GQ12520@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126164918.GQ12520@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 05:49:18PM +0100, Tejun Heo wrote:
> With cmwq, there's no reason for nouveau to use a dedicated workqueue.
> Drop dev_priv->wq and use system_wq instead.  Each work item is sync
> flushed when the containing structure is unregistered/destroyed.
> 
> Note that this change also makes sure that nv50_gpio_handler is not
> freed while the contained work item is still running.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: David Airlie <airlied@linux.ie>
> Cc: dri-devel@lists.freedesktop.org

Ping.  Can you please put this through the drm tree?

Thank you.

-- 
tejun
