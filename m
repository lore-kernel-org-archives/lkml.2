Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935370Ab1JEUIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 16:08:19 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37777 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935116Ab1JEUIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 16:08:17 -0400
Subject: Re: Re: Re: BUG in kernel: Wrong Handling of USB
 =?UTF-8?Q?HDD=E2=80=99s?= in scsiglue(slave_configure) and
 scsi/sd(sd_read_cache_type)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <CADDb1s031VX65+G-Uq-12y4qWq98-OS6DKz7mUCo=8AQkVQVTQ@mail.gmail.com>
References: <CADDb1s0ZnHzM72sDnFmRrM=GFJtxj5JkYUSPo6GdyQ_=7L2m9A@mail.gmail.com>
	 <Pine.LNX.4.44L0.1110041007070.1954-100000@iolanthe.rowland.org>
	 <CADDb1s0taBR2=xpKE5rLJTWJBMbXijS8b_GEA-MbZvWKFDFvYg@mail.gmail.com>
	 <CADDb1s3sPxpfNi-OD=QvVT+JWO9kUeTAmb8ZGyN0YCuBKWd4rg@mail.gmail.com>
	 <CADDb1s3FN4Ft2yXs-L8LfhoJEDP+KhSCrG8GGbOUgn_GXEr0yA@mail.gmail.com>
	 <1317835442.7238.8.camel@dabdike>
	 <CADDb1s031VX65+G-Uq-12y4qWq98-OS6DKz7mUCo=8AQkVQVTQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 13:08:15 -0700
Message-ID: <1317845295.7238.15.camel@dabdike>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 01:21 +0530, Amit Sahrawat wrote:
> > The best we could probably offer is an interface to turn on the WCE bit
> > in software (technically, you can do this today
> > in /scsi/class/scsi_disk/<disk>/cache_type, it's just that it will try
> > to commit the change as a MODE_SELECT which will presumably fail).
> Thanks James, is this related with SCSI command MODE_SELECT? and this
> is to be passed when there is some failure?
> or simply doing an "echo <value>" to
> /scsi/class/scsi_disk/<disk>/cache_type? can you please elaborate a
> little

You tell me since you have the device.  What that echo does is that it
does try to make the change permanent with a mode select ... that likely
won't work and the cache change only takes if the revalidated disk says
the write back has been enabled (which I really think it won't).  So I
think you need an additional software bit to flip for the case where the
device lies.

James


