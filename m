Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab2GBBw4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 21:52:56 -0400
Received: from ozlabs.org ([203.10.76.45]:56836 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250Ab2GBBwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 21:52:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Asias He <asias@redhat.com>, Sasha Levin <levinsasha928@gmail.com>
Cc: dlaor@redhat.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] virtio-blk: Add bio-based IO path for virtio-blk
In-Reply-To: <4FDFE926.7030309@redhat.com>
References: <1340002390-3950-1-git-send-email-asias@redhat.com>  <1340002390-3950-4-git-send-email-asias@redhat.com>  <87hau9yse7.fsf@rustcorp.com.au> <4FDEE0CB.1030505@redhat.com>  <87zk81x7dp.fsf@rustcorp.com.au> <4FDF0DA7.40604@redhat.com> <1340019575.22848.2.camel@lappy> <4FDFE926.7030309@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 02 Jul 2012 09:24:27 +0930
Message-ID: <87r4svxcjw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2012 10:51:18 +0800, Asias He <asias@redhat.com> wrote:
> On 06/18/2012 07:39 PM, Sasha Levin wrote:
> > On Mon, 2012-06-18 at 14:14 +0300, Dor Laor wrote:
> >> On 06/18/2012 01:05 PM, Rusty Russell wrote:
> >>> On Mon, 18 Jun 2012 16:03:23 +0800, Asias He<asias@redhat.com>  wrote:
> >>>> On 06/18/2012 03:46 PM, Rusty Russell wrote:
> >>>>> On Mon, 18 Jun 2012 14:53:10 +0800, Asias He<asias@redhat.com>  wrote:
> >>>>>> This patch introduces bio-based IO path for virtio-blk.
> >>>>>
> >>>>> Why make it optional?
> >>>>
> >>>> request-based IO path is useful for users who do not want to bypass the
> >>>> IO scheduler in guest kernel, e.g. users using spinning disk. For users
> >>>> using fast disk device, e.g. SSD device, they can use bio-based IO path.
> >>>
> >>> Users using a spinning disk still get IO scheduling in the host though.
> >>> What benefit is there in doing it in the guest as well?
> >>
> >> The io scheduler waits for requests to merge and thus batch IOs
> >> together. It's not important w.r.t spinning disks since the host can do
> >> it but it causes much less vmexits which is the key issue for VMs.
> >
> > Is the amount of exits caused by virtio-blk significant at all with
> > EVENT_IDX?
> 
> Yes. EVENT_IDX saves the number of notify and interrupt. Let's take the 
> interrupt as an example, The guest fires 200K request to host, the 
> number of interrupt is about 6K thanks to EVENT_IDX. The ratio is 200K / 
> 6K = 33. The ratio of merging is 40000K / 200K = 20.

Confused.  So, without merging we get 6k exits (per second?)  How many
do we get when we use the request-based IO path?

If your device is slow, then you won't be able to make many requests per
second: why worry about exit costs?  If your device is fast (eg. ram),
you've already shown that your patch is a win, right?

Cheers,
Rusty.
