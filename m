Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab1HRPLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 11:11:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490Ab1HRPLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 11:11:18 -0400
Message-ID: <4E4D2B6D.1040908@redhat.com>
Date: Thu, 18 Aug 2011 08:10:37 -0700
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: Add stats VQ to collect information about
 devices
References: <1313524071-27250-1-git-send-email-levinsasha928@gmail.com>  <4E4C481A.5080205@redhat.com> <1313642283.22532.4.camel@lappy>
In-Reply-To: <1313642283.22532.4.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2011 09:38 PM, Sasha Levin wrote:
> On Wed, 2011-08-17 at 16:00 -0700, Avi Kivity wrote:
> >  On 08/16/2011 12:47 PM, Sasha Levin wrote:
> >  >  This patch adds support for an optional stats vq that works similary to the
> >  >  stats vq provided by virtio-balloon.
> >  >
> >  >  The purpose of this change is to allow collection of statistics about working
> >  >  virtio-blk devices to easily analyze performance without having to tap into
> >  >  the guest.
> >  >
> >  >
> >
> >  Why can't you get the same info from the host?  i.e. read sectors?
>
> Some of the stats you can collect from the host, but some you can't.
>
> The ones you can't include all the timing statistics and the internal
> queue statistics (read/write merges).

Surely you can time the actual amount of time the I/O takes?  It doesn't 
account for the virtio round-trip, but does it matter?

Why is the merge count important for the host?

>
> The idea behind providing all of the stats on the stats vq (which is
> basically what you see in '/dev/block/[device]/stats') is to give a
> consistent snapshot of the state of the device.
>
>

What can you do with it?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

