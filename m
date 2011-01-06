Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab1AFEcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 23:32:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab1AFEcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 23:32:07 -0500
Subject: Re: [PATCH 09/32] drm/radeon: use system_wq instead of dev_priv->wq
From: Dave Airlie <airlied@redhat.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
In-Reply-To: <AANLkTin0PtAj+RynsePYHcgVw3Oe0fq5kQMLU9z=V_1e@mail.gmail.com>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
	 <1294062595-30097-10-git-send-email-tj@kernel.org>
	 <AANLkTin0PtAj+RynsePYHcgVw3Oe0fq5kQMLU9z=V_1e@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Jan 2011 14:31:39 +1000
Message-ID: <1294288300.8921.0.camel@clockmaker-el6>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 19:21 -0500, Alex Deucher wrote:
> On Mon, Jan 3, 2011 at 8:49 AM, Tejun Heo <tj@kernel.org> wrote:
> > With cmwq, there's no reason for radeon to use a dedicated workqueue.
> > Drop dev_priv->wq and use system_wq instead.
> >
> > Because radeon_driver_irq_uninstall_kms() may be called from
> > unsleepable context, the work items can't be flushed from there.
> > Instead, init and flush from radeon_irq_kms_init/fini().
> >
> > While at it, simplify canceling/flushing of rdev->pm.dynpm_idle_work.
> > Always initialize and sync cancel instead of being unnecessarily smart
> > about it.
> >
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: David Airlie <airlied@linux.ie>
> > Cc: dri-devel@lists.freedesktop.org
> > ---
> > Only compile tested.  Please feel free to take it into the subsystem
> > tree or simply ack - I'll route it through the wq tree.
> 
> Patch looks good to me.  I'm not sure what's the best way to send this
> upstream.  I'm working on some irq changes in the same area now, so
> I'd prefer if we pushed it through Dave's tree, but I can handle it
> either way.

I'll pull it into my tree for merging to Linus.

Dave.

> 
> Acked-by: Alex Deucher <alexdeucher@gmail.com>
> 


