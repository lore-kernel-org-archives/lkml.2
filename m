Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab2JKIK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 04:10:26 -0400
Received: from mx0.aculab.com ([213.249.233.131]:36548 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754870Ab2JKIKS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 04:10:18 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH net-next?] pktgen: Use simpler test for non-zero ipv6 address
Date: Thu, 11 Oct 2012 09:08:52 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7036@saturn3.aculab.com>
In-Reply-To: <1349894559.2035.12.camel@joe-AO722>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH net-next?] pktgen: Use simpler test for non-zero ipv6 address
thread-index: Ac2nFwRCF6WrQUv2ReKzWZ/cEeg+zwAcHFVA
References: <1349894559.2035.12.camel@joe-AO722>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Joe Perches" <joe@perches.com>, "netdev" <netdev@vger.kernel.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -		if (pkt_dev->min_in6_daddr.s6_addr32[0] == 0 &&
> -		    pkt_dev->min_in6_daddr.s6_addr32[1] == 0 &&
> -		    pkt_dev->min_in6_daddr.s6_addr32[2] == 0 &&
> -		    pkt_dev->min_in6_daddr.s6_addr32[3] == 0) ;
> -		else {
> +		if (pkt_dev->min_in6_daddr.s6_addr32[0] |
> +		    pkt_dev->min_in6_daddr.s6_addr32[1] |
> +		    pkt_dev->min_in6_daddr.s6_addr32[2] |
> +		    pkt_dev->min_in6_daddr.s6_addr32[3]) {

Given the likely values, it might be worth using:
		if (pkt_dev->min_in6_daddr.s6_addr32[0] == 0 &&
		    pkt_dev->min_in6_daddr.s6_addr32[1] |
		    pkt_dev->min_in6_daddr.s6_addr32[2] |
		    pkt_dev->min_in6_daddr.s6_addr32[3]) {

	David



