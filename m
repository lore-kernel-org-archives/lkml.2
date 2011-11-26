Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab1KZPmV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 10:42:21 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43123 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752620Ab1KZPmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 10:42:18 -0500
X-Sasl-enc: p7jW8Q2OdD+cO+FhUb8VfAPz6wBzO1kNn/hbq8JeZPlQ 1322322136
Date: Sat, 26 Nov 2011 07:41:50 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, linux-kernel@vger.kernel.org
Subject: Re: Fix build breakage in your tree in the drivers/staging/iio
 directory
Message-ID: <20111126154150.GA5339@kroah.com>
References: <20111126151013.GA16446@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111126151013.GA16446@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 07:10:13AM -0800, Greg KH wrote:
> Linus, can you please revert b46413367961c2e8bd827e067a231be982aaeee2 in
> your tree?  It breaks the build and didn't seem to be tested by Al.
> 
> I'll prepare a fix for this based on Al's patch, that doesn't break
> things and send it to you later next week (I'm about to jump on a plane
> for Tokyo in a few hours and can't test one at the moment), but for now,
> this should be reverted as I'm getting lots of emails about it.

Or, here's a simple one-line patch that fixes the build breakage, if you
just want to apply it instead:

-------------------

From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: fix build breakage in drivers/staging/iio/industrialio-core.c

This was introduced in commit b46413367961c2e8bd827e067a231be982aaeee2
(iio: fix a leak due to improper use of anon_inode_getfd())

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 2656409..6542489 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -259,7 +259,7 @@ static int iio_event_getfd(struct iio_dev *indio_dev)
 				indio_dev->event_interface, O_RDONLY);
 	if (fd < 0) {
 		mutex_lock(&indio_dev->event_interface->event_list_lock);
-		clear_bit(IIO_BUSY_BIT_POS, &ev_int->flags);
+		clear_bit(IIO_BUSY_BIT_POS, &indio_dev->event_interface->flags);
 		mutex_unlock(&indio_dev->event_interface->event_list_lock);
 	}
 	return fd;
