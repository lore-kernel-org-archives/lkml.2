Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab1BVMyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 07:54:22 -0500
Received: from sputnik.urmx.de ([88.198.51.18]:58406 "EHLO sputnik.urmx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab1BVMyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 07:54:20 -0500
X-Spam-Processed: srv201.gdsys.de, Tue, 22 Feb 2011 13:54:17 +0100
	(not processed: message from trusted or authenticated source)
X-Return-Path: Eibach@gdsys.de
X-Envelope-From: Eibach@gdsys.de
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4721
Date: Tue, 22 Feb 2011 13:52:58 +0100
Message-ID: <48D3D52125C49B43AE880038E2E5314BB5BE5E@SRV101.gdsys.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-index: AcvSjaUu+1r5UGtPQFSGGAtYvbpAkwAAX3Gw
References: <1298365010-22951-1-git-send-email-eibach@gdsys.de> <20110222123601.GA1966@bicker>
From: "Eibach, Dirk" <Eibach@gdsys.de>
To: <linux-kernel@vger.kernel.org>
X-SafeGuard_MailGateway: Version: 5.60.3.10058 SGMG Date: 20110222125420Z
Subject: RE: [PATCH] gpio: Fix wrong pointer type in pca953x
Thread-Topic: RE: [PATCH] gpio: Fix wrong pointer type in pca953x
Content-Class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.9.4.170; VDF: 7.11.3.178; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> >  	struct pca953x_platform_data *pdata;
> >  	struct device_node *node;
> > -	const uint16_t *val;
> > +	const u32 *val;
> >  
> 
> This should probably be signed?  We compare it against zero later on.
> 
>                 if (*val < 0)
>                         dev_warn(&client->dev,
>                                  "invalid gpio-base in device 
> tree\n");

Good catch.
of property values are generally unsigned. The whole check is bogus
here. Will supply updated patch later.

> regards,
> dan carpenter

Cheers
Dirk


