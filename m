Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab2AEKnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 05:43:16 -0500
Received: from mx0.aculab.com ([213.249.233.131]:41659 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756911Ab2AEKnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 05:43:14 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 5/6] ath6kl: convert ath6kl_dbg() and ath6kl_dbg_dump() into functions
Date: Thu, 5 Jan 2012 10:41:28 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AF2F@saturn3.aculab.com>
In-Reply-To: <1325720472.4116.7.camel@joe2Laptop>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 5/6] ath6kl: convert ath6kl_dbg() and ath6kl_dbg_dump() into functions
Thread-Index: AczLOkiAZyCQ9KCWRuap1YxWvLGTUwAWwuMg
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Joe Perches" <joe@perches.com>, "Kalle Valo" <kvalo@qca.qualcomm.com>
Cc: <linville@tuxdriver.com>, <sfr@canb.auug.org.au>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
        <davem@davemloft.net>
X-OriginalArrivalTime: 05 Jan 2012 10:41:28.0444 (UTC) FILETIME=[9488FBC0:01CCCB96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > +	va_start(args, fmt);
> > +	ath6kl_printk(KERN_DEBUG, fmt, &args);
> 
> Passing a va_list as an argument?
> I believe this doesn't work.
> I think you'll need to add and use:

Passing a va_list certainly does work - vprintf() etc.
What is problematical is taking the address of a va_list.

The likely problem is a 'levels of indirection' one
because, when va_list needs to be a struct (very
likely when arguments are passed in registers),
it is often declared as as array type.

	David


