Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781Ab2DJOVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 10:21:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab2DJOVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 10:21:51 -0400
Date: Tue, 10 Apr 2012 10:21:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH] block: Change default IO scheduler to deadline
 except SATA
Message-ID: <20120410142148.GG21801@redhat.com>
References: <20120410133708.GE21801@redhat.com>
 <4F843C17.5050004@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F843C17.5050004@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 03:56:39PM +0200, Jens Axboe wrote:
> On 2012-04-10 15:37, Vivek Goyal wrote:
> > Hi,
> > 
> > I am wondering if CFQ as default scheduler is still the right choice. CFQ
> > generally works well on slow rotational media (SATA?). But often
> > underperforms on faster storage (storage arrays, PCIE SSDs, virtualized
> > disk in linux guests etc). People often put logic in user space to tune their
> > systems and change IO scheduler to deadline to get better performance on
> > faster storage.
> > 
> > Though there is not one good answer for all kind of storage and for all
> > kind of workloads, I am wondering if we can provide a better default and
> > that is change default IO scheduler to "deadline" except SATA.
> > 
> > One can argue that some SAS disks can be slow too and benefit from CFQ. Yes,
> > but default IO scheduler choice is not perfect anyway. It just tries to
> > cater to a wide variety of use cases out of the box.
> > 
> > So I am throwing this patch out see if it flies. Personally, I think it
> > might turn out to be a more reasonable default.
> 
> I think it'd be a lot more sane to just use CFQ on rotational single
> devices, and default to deadline on raid or non-rotational devices. This
> still isn't perfect, since less worthy SSDs still benefit from the
> read/write separation, and some multi device configs will be faster as
> well. But it's better.

Hi Jens,

Thanks. Taking a decision based on rotational flag makes sense. I am
not sure that does one get the information that a block device is a single
device or not. Especially with HBAs, SCSI Luns over Fiber, iSCSI Luns etc.
I have few Scsi Luns exported to me backed by a storage array. Everything
runs CFQ by default. And though disks in the array are rotational, they
are RAIDed and AFAIK, this information is not available to driver.

I am not sure if there is an easy way to get similar info for dm/md devices.

> 
> The below patch is not a good idea. There's no clear distinction between
> on what CFQ is now the default.

Can it be thought of as that block layer default is "deadline" and driver
can override it. Yes, I agree that it is not very clear though.

Thanks
Vivek
