Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab1HREjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 00:39:16 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60994 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab1HREjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 00:39:15 -0400
Subject: Re: [PATCH] virtio-blk: Add stats VQ to collect information about
 devices
From: Sasha Levin <levinsasha928@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
In-Reply-To: <4E4C481A.5080205@redhat.com>
References: <1313524071-27250-1-git-send-email-levinsasha928@gmail.com>
	 <4E4C481A.5080205@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 18 Aug 2011 07:38:03 +0300
Message-ID: <1313642283.22532.4.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-17 at 16:00 -0700, Avi Kivity wrote:
> On 08/16/2011 12:47 PM, Sasha Levin wrote:
> > This patch adds support for an optional stats vq that works similary to the
> > stats vq provided by virtio-balloon.
> >
> > The purpose of this change is to allow collection of statistics about working
> > virtio-blk devices to easily analyze performance without having to tap into
> > the guest.
> >
> >
> 
> Why can't you get the same info from the host?  i.e. read sectors?

Some of the stats you can collect from the host, but some you can't.

The ones you can't include all the timing statistics and the internal
queue statistics (read/write merges).

The idea behind providing all of the stats on the stats vq (which is
basically what you see in '/dev/block/[device]/stats') is to give a
consistent snapshot of the state of the device.

> 
> Patches to virtio drivers should be preceded by specification updates so 
> that guest driver authors and alternative userspace developers have a 
> solid reference.
> 

I'll send an additional update to the spec.

-- 

Sasha.

