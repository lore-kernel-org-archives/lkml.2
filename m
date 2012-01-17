Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab2AQHa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 02:30:28 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:58806 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab2AQHa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 02:30:26 -0500
Date: Tue, 17 Jan 2012 10:30:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 2/2] [media] ds3000: off by one in ds3000_read_snr()
Message-ID: <20120117073021.GB11358@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4F15238E.0029,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a static checker patch and I don't have the hardware to test
this, so please review it carefully.  The dvbs2_snr_tab[] array has 80
elements so when we cap it at 80, that's off by one.  I would have
assumed that the test was wrong but in the lines right before we have
the same test but use "snr_reading - 1" as the array offset.  I've done
the same thing here.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
index af65d01..3f5ae0a 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -681,7 +681,7 @@ static int ds3000_read_snr(struct dvb_frontend *fe, u16 *snr)
 			snr_reading = dvbs2_noise_reading / tmp;
 			if (snr_reading > 80)
 				snr_reading = 80;
-			*snr = -(dvbs2_snr_tab[snr_reading] / 1000);
+			*snr = -(dvbs2_snr_tab[snr_reading - 1] / 1000);
 		}
 		dprintk("%s: raw / cooked = 0x%02x / 0x%04x\n", __func__,
 				snr_reading, *snr);
