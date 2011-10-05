Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935254Ab1JETvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:51:15 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60080 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933233Ab1JETvN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:51:13 -0400
MIME-Version: 1.0
In-Reply-To: <1317835442.7238.8.camel@dabdike>
References: <CADDb1s0ZnHzM72sDnFmRrM=GFJtxj5JkYUSPo6GdyQ_=7L2m9A@mail.gmail.com>
	<Pine.LNX.4.44L0.1110041007070.1954-100000@iolanthe.rowland.org>
	<CADDb1s0taBR2=xpKE5rLJTWJBMbXijS8b_GEA-MbZvWKFDFvYg@mail.gmail.com>
	<CADDb1s3sPxpfNi-OD=QvVT+JWO9kUeTAmb8ZGyN0YCuBKWd4rg@mail.gmail.com>
	<CADDb1s3FN4Ft2yXs-L8LfhoJEDP+KhSCrG8GGbOUgn_GXEr0yA@mail.gmail.com>
	<1317835442.7238.8.camel@dabdike>
Date: Thu, 6 Oct 2011 01:21:11 +0530
Message-ID: <CADDb1s031VX65+G-Uq-12y4qWq98-OS6DKz7mUCo=8AQkVQVTQ@mail.gmail.com>
Subject: =?windows-1252?Q?Re=3A_Re=3A_Re=3A_BUG_in_kernel=3A_Wrong_Handling_of_USB_HDD?=
	=?windows-1252?Q?=92s_in_scsiglue=28slave=5Fconfigure=29_and_scsi=2Fsd=28sd=5Fread=5Fcache=5F?=
	=?windows-1252?Q?type=29?=
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 5, 2011 at 10:54 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Wed, 2011-10-05 at 22:29 +0530, Amit Sahrawat wrote:
>> Can anyone suggest what is the way ahead to detect the presence of
>> Write Cache in these kind of USB HDD and proceed accordingly by
>> assigning proper flushing method.
>> Please share some opinions on this.
>
> We're a bit out of ideas.  We've already established that we do exactly
> what windows does in this situation, which is usually what we aim for.
> Realistically, if the disks lie how do we know when not to believe them?
I never knew this could turn out to be an issue with such history. But
atleast debugging helped in diagnosis.
>
> The best we could probably offer is an interface to turn on the WCE bit
> in software (technically, you can do this today
> in /scsi/class/scsi_disk/<disk>/cache_type, it's just that it will try
> to commit the change as a MODE_SELECT which will presumably fail).
Thanks James, is this related with SCSI command MODE_SELECT? and this
is to be passed when there is some failure?
or simply doing an "echo <value>" to
/scsi/class/scsi_disk/<disk>/cache_type? can you please elaborate a
little
>
> James
>
Thanks & Regards,
Amit Sahrawat
