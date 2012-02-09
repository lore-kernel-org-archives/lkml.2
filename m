Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab2BIKAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 05:00:06 -0500
Received: from mx0.aculab.com ([213.249.233.131]:34366 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757654Ab2BIKAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 05:00:03 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 08/50] bnx2x: use dev_hw_addr_random() instead of random_ether_addr()
Date: Thu, 9 Feb 2012 09:59:35 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6E5F@saturn3.aculab.com>
In-Reply-To: <1328735457-29986-9-git-send-email-danny.kukawka@bisect.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 08/50] bnx2x: use dev_hw_addr_random() instead of random_ether_addr()
Thread-Index: Aczmpi+KNzrRmdTQT6GaBLOTEZcMKAAaxgFQ
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Danny Kukawka" <danny.kukawka@bisect.de>,
        "David S. Miller" <davem@davemloft.net>
Cc: "Danny Kukawka" <dkukawka@suse.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Eilon Greenstein" <eilong@broadcom.com>
X-OriginalArrivalTime: 09 Feb 2012 09:59:36.0449 (UTC) FILETIME=[87BA3710:01CCE711]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> +	if (dev->addr_assign_type & NET_ADDR_RANDOM)
> +		dev->addr_assign_type ^= NET_ADDR_RANDOM;

Why not just:
	dev->addr_assign_type &= ~NET_ADDR_RANDOM;
the cache is probably dirty and it won't be a critical path.

	David


