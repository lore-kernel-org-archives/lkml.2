Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab1BDByI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 20:54:08 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60002 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab1BDByH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 20:54:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:date:in-reply-to:references
         :content-type:x-mailer:content-transfer-encoding:message-id
         :mime-version;
        b=PIEUWksfHog0hYaTxEGndb02CQ2A4N3B1nqFTPBbqxaKK6sTZ+e08kjc2UyQAkSQOO
         LPae4salOuOpknn8A1bJIKBLTWnOanMPfhKrwzJhkVPZdCZQ+nAVOvAtckI38gy1GIIi
         G6j2LF185AlwSWx5hyMGy1SBNKo7mhHPEes2g=
Subject: Re: [PATCH UPDATED 08/32] drm/nouveau: use system_wq instead of
 dev_priv->wq
From: Ben Skeggs <skeggsb@gmail.com>
Reply-To: skeggsb@gmail.com
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Date: Fri, 04 Feb 2011 11:53:25 +1000
In-Reply-To: <20110201104135.GI14211@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
	 <1294062595-30097-9-git-send-email-tj@kernel.org>
	 <1294189627.2276.0.camel@nisroch> <1294190172.2276.2.camel@nisroch>
	 <20110106172922.GA29580@mtj.dyndns.org>
	 <20110126164918.GQ12520@htj.dyndns.org>
	 <20110201104135.GI14211@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.5 (2.91.5-4.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1296784411.7970.1.camel@nisroch>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 11:41 +0100, Tejun Heo wrote:
> On Wed, Jan 26, 2011 at 05:49:18PM +0100, Tejun Heo wrote:
> > With cmwq, there's no reason for nouveau to use a dedicated workqueue.
> > Drop dev_priv->wq and use system_wq instead.  Each work item is sync
> > flushed when the containing structure is unregistered/destroyed.
> > 
> > Note that this change also makes sure that nv50_gpio_handler is not
> > freed while the contained work item is still running.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: David Airlie <airlied@linux.ie>
> > Cc: dri-devel@lists.freedesktop.org
> 
> Ping.  Can you please put this through the drm tree?
Hey Tejun,

Thanks for this again.  I've just made some changes to the nv50 display
bottom half handling that these will conflict with, they'll hit the
nouveau tree next week.

I'll push the still-relevant bits of your nouveau patch through the
nouveau tree for the 2.6.39-rc1 merge window.  That ok?

Thanks,
Ben.

> 
> Thank you.
> 


