Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab2LEPXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 10:23:53 -0500
Received: from mx0.aculab.com ([213.249.233.131]:34943 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752183Ab2LEPXv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 10:23:51 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2] net/macb: Use non-coherent memory for rx buffers
Date: Wed, 5 Dec 2012 15:22:14 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B70DB@saturn3.aculab.com>
In-Reply-To: <50BF6467.5060701@atmel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2] net/macb: Use non-coherent memory for rx buffers
Thread-Index: Ac3S+tNQBB1VasVESWKUxbKg8XuASQAAMm+w
References: <CAGhQ9VwWmP_B17LnAEqDHcL8Yd-s0C-Bf35z3+=vnJmK_NoCSw@mail.gmail.com> <1354536876-6274-1-git-send-email-nicolas.ferre@atmel.com> <AE90C24D6B3A694183C094C60CF0A2F6026B70D5@saturn3.aculab.com> <50BCA746.1020705@atmel.com> <AE90C24D6B3A694183C094C60CF0A2F6026B70D6@saturn3.aculab.com> <50BE2FEC.2070500@atmel.com> <AE90C24D6B3A694183C094C60CF0A2F6026B70D9@saturn3.aculab.com> <50BF6467.5060701@atmel.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Nicolas Ferre" <nicolas.ferre@atmel.com>
Cc: "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Joachim Eastwood" <manabian@gmail.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        "Havard Skinnemoen" <havard@skinnemoen.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, for the 10/100 MACB interface, I am stuck with 128 Bytes buffers!
> So this use of pages seems sensible.

If you have dma coherent memory you can make the rx buffer space
be an array of short buffers referenced by adjacent ring entries
(possibly with the last one slightly short to allow for the
2 byte offset).
Then, when a big frame ends up in multiple buffers, you need
a maximum of two copies to extract the data.

	David



