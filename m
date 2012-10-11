Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2JKIVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 04:21:50 -0400
Received: from mx0.aculab.com ([213.249.233.131]:36855 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751237Ab2JKIVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 04:21:47 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC net-next] treewide: s/ipv4_is_<foo>()/ipv4_addr_<foo>/
Date: Thu, 11 Oct 2012 09:11:18 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7037@saturn3.aculab.com>
In-Reply-To: <1349897923.2035.31.camel@joe-AO722>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [RFC net-next] treewide: s/ipv4_is_<foo>()/ipv4_addr_<foo>/
thread-index: Ac2nHttqP8pW+H/rSdWSgVYelriehwAaOLSA
References: <1349894559.2035.12.camel@joe-AO722> <1349895710.21172.7235.camel@edumazet-glaptop> <1349897005.2035.24.camel@joe-AO722> <1349897923.2035.31.camel@joe-AO722>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Joe Perches" <joe@perches.com>, "Eric Dumazet" <eric.dumazet@gmail.com>,
        "David Miller" <davem@davemloft.net>
Cc: "netdev" <netdev@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>,
        "Brian Haley" <brian.haley@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ipv4 and ipv6 use different styles for these tests.
> 
> ipv4_is_<foo>(__be32)
> ipv6_addr_<foo>(struct in6_addr *)

I presume there is a 'const' in there ...

> Perhaps it'd be good to convert the ipv4 tests to the ipv6 style.

You don't want to force an IPv4 address (which might be in a register)
be written out to stack.
Taking the address also has implications for the optimiser.

	David



