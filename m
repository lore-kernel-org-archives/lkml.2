Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab2FRLil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:38:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42237 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2FRLik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:38:40 -0400
Message-ID: <1340019575.22848.2.camel@lappy>
Subject: Re: [PATCH 3/3] virtio-blk: Add bio-based IO path for virtio-blk
From: Sasha Levin <levinsasha928@gmail.com>
To: dlaor@redhat.com
Cc: Rusty Russell <rusty@rustcorp.com.au>, Asias He <asias@redhat.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Christoph Hellwig <hch@lst.de>
Date: Mon, 18 Jun 2012 13:39:35 +0200
In-Reply-To: <4FDF0DA7.40604@redhat.com>
References: <1340002390-3950-1-git-send-email-asias@redhat.com>
	 <1340002390-3950-4-git-send-email-asias@redhat.com>
	 <87hau9yse7.fsf@rustcorp.com.au> <4FDEE0CB.1030505@redhat.com>
	 <87zk81x7dp.fsf@rustcorp.com.au> <4FDF0DA7.40604@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-18 at 14:14 +0300, Dor Laor wrote:
> On 06/18/2012 01:05 PM, Rusty Russell wrote:
> > On Mon, 18 Jun 2012 16:03:23 +0800, Asias He<asias@redhat.com>  wrote:
> >> On 06/18/2012 03:46 PM, Rusty Russell wrote:
> >>> On Mon, 18 Jun 2012 14:53:10 +0800, Asias He<asias@redhat.com>  wrote:
> >>>> This patch introduces bio-based IO path for virtio-blk.
> >>>
> >>> Why make it optional?
> >>
> >> request-based IO path is useful for users who do not want to bypass the
> >> IO scheduler in guest kernel, e.g. users using spinning disk. For users
> >> using fast disk device, e.g. SSD device, they can use bio-based IO path.
> >
> > Users using a spinning disk still get IO scheduling in the host though.
> > What benefit is there in doing it in the guest as well?
> 
> The io scheduler waits for requests to merge and thus batch IOs 
> together. It's not important w.r.t spinning disks since the host can do 
> it but it causes much less vmexits which is the key issue for VMs. 

Is the amount of exits caused by virtio-blk significant at all with
EVENT_IDX?

