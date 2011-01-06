Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab1AFR3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 12:29:39 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59405 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab1AFR3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 12:29:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eANATpnKzx4vA/frwBnD3qadOlxYezMm1+x3frH8uWZuRvHJQQStlXSsdlXtXQzWML
         THpp70P3ijohnb3mFSdbjJ2oQj/PH/+kx3LMRvf1OYLuMnhLYHu55teeRiFuEXQTZYxN
         h2UycF6wftqOShCXMVsg2vyK8grePccGgtmBA=
Date: Thu, 6 Jan 2011 09:29:22 -0800
From: Tejun Heo <tj@kernel.org>
To: Ben Skeggs <skeggsb@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 08/32] drm/nouveau: use system_wq instead of
 dev_priv->wq
Message-ID: <20110106172922.GA29580@mtj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-9-git-send-email-tj@kernel.org>
 <1294189627.2276.0.camel@nisroch>
 <1294190172.2276.2.camel@nisroch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294190172.2276.2.camel@nisroch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 05, 2011 at 11:16:05AM +1000, Ben Skeggs wrote:
> On Wed, 2011-01-05 at 11:07 +1000, Ben Skeggs wrote:
> > On Mon, 2011-01-03 at 14:49 +0100, Tejun Heo wrote:
> > > With cmwq, there's no reason for nouveau to use a dedicated workqueue.
> > > Drop dev_priv->wq and use system_wq instead.
> > > 
> > > Because nouveau_irq_uninstall() may be called from unsleepable
> > > context, the work items can't be flushed from there.  Instead, init
> > > and flush from nouveau_load/unload().
> > Ehh, ok, why not!  I'll push this through the nouveau tree, and it'll
> > get to Dave from there.
>
> On second thoughts, this won't apply on top of current nouveau code
> that's queued for 2.6.38.  Can you rebase on top of Dave's drm-next tree
> please.

We already missed this merge window, so I'll refresh the patch once
the window is closed and resend.

Thank you.

-- 
tejun
