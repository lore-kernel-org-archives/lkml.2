Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937668Ab0CPKEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 06:04:55 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:35511 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937656Ab0CPKEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 06:04:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=lfDi4KlTDg9BDz/Nf5imWVGmY8HLhpfEAD+stJFiJH9scVCdRx2BaZSvpYuikvlQpl
         a41p9c1lrzKtb+oH3aDrlvJm3ttyWVu91ieCRdgLjlEkkLJqkyuoJrFXbGb2wJOoNdjX
         1KYFPCFy6ptb0KT/CHJhaQKz1vzEFSaujCzBE=
Date: Tue, 16 Mar 2010 13:03:49 +0300
From: Dan Carpenter <error27@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] iio: test for failed allocation
Message-ID: <20100316100349.GA4219@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Jonathan Cameron <jic23@cam.ac.uk>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should return test to see if iio_allocate_trigger() fails and return -ENOMEM.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
index a6b7c72..db3270f 100644
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c
+++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -492,6 +492,9 @@ int lis3l02dq_probe_trigger(struct iio_dev *indio_dev)
 	struct lis3l02dq_state *state = indio_dev->dev_data;
 
 	state->trig = iio_allocate_trigger();
+	if (!state->trig)
+		return -ENOMEM;
+
 	state->trig->name = kmalloc(IIO_TRIGGER_NAME_LENGTH, GFP_KERNEL);
 	if (!state->trig->name) {
 		ret = -ENOMEM;
