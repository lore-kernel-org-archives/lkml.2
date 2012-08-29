Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab2H2Wvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 18:51:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab2H2Wvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 18:51:36 -0400
Date: Thu, 30 Aug 2012 01:52:49 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: avi@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 2/2] virtio-ring: Allocate indirect buffers from cache
 when possible
Message-ID: <20120829225249.GB9146@redhat.com>
References: <1346159043-16446-1-git-send-email-levinsasha928@gmail.com>
 <1346159043-16446-2-git-send-email-levinsasha928@gmail.com>
 <20120829153812.GD7407@redhat.com>
 <503E4DD9.1020102@gmail.com>
 <20120829181235.GE7877@redhat.com>
 <503E7F9B.8010402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503E7F9B.8010402@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 10:46:19PM +0200, Sasha Levin wrote:
> On 08/29/2012 08:12 PM, Michael S. Tsirkin wrote:
> >>> > > What is a good default for net? I guess max sg?
> >> > 
> >> > I think that it depends on the workload. I'd say we should keep the default to 0
> >> > (disabled) unless we can have a good way to adjust it to the load.
> > For *all* drivers?
> > 
> > Then it is mostly useless. No one has the time to tweak module
> > parameters in real life.
> > 
> > For virtio-net, 16+1 is not too much and ensures we always
> > use the cache.
> > 
> > If that works better than 0 I would say run with 17.
> 
> I was being extra-cautious with leaving it disabled until specifically enabled
> because I assumed that this would be one of the first comments I'll get if it
> was enabled by default :)
> 
> If you're comfortable with setting it to a sane default like 17, I'm perfectly
> fine with that as well.
> 
> 
> Thanks,
> Sasha

If our testing shows it helps and does not trigger regressions, then
why not? module params are mostly there for developers.
They are not all that helpful to users.

> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
