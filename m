Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab2IXOXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:23:53 -0400
Received: from mx0.aculab.com ([213.249.233.131]:36656 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755633Ab2IXOXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:23:07 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v4] lxt PHY: Support for the buggy LXT973 rev A2
Date: Mon, 24 Sep 2012 15:13:41 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7004@saturn3.aculab.com>
In-Reply-To: <201209241400.q8OE0w38011790@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v4] lxt PHY: Support for the buggy LXT973 rev A2
thread-index: Ac2aXSAWJRjYtwTKQp+nHU2B18H2OgAAMRJg
References: <201209241400.q8OE0w38011790@localhost.localdomain>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Christophe Leroy" <christophe.leroy@c-s.fr>,
        "David S Miller" <davem@davemloft.net>,
        "Richard Cochran" <richardcochran@gmail.com>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds proper handling of the buggy revision A2 of LXT973 phy, adding
> precautions linked to ERRATA Item 4:
> 
> Revision A2 of LXT973 chip randomly returns the contents of the previous even
> register when you read a odd register regularly

Does reading the PHY registers involve bit-banging an MII interface?
If so this code is likely to stall the system for significant
periods (ready phy registers at all can be a problem).

I know some ethernet mac have hardware blocks for reading MII
and even polling one MII register for changes.

Maybe some of this code ought to be using async software
bit-bang - especially when just polling for link status change.
I'm sure it ought to be possible to do one bit-bang action
per clock tick instead of spinning for the required delays. 

	David



