Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab2APQUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:20:52 -0500
Received: from mx0.aculab.com ([213.249.233.131]:50494 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755463Ab2APQUu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:20:50 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] pch_gbe: Use a randomly generated MAC instead of failing probe
Date: Mon, 16 Jan 2012 16:20:45 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AF47@saturn3.aculab.com>
In-Reply-To: <4F144B4F.7050905@linux.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] pch_gbe: Use a randomly generated MAC instead of failing probe
Thread-Index: AczUaQatCadqeCGhRImEIufyqS02+wAAUgqw
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Arjan van de Ven" <arjan@linux.intel.com>,
        "Darren Hart" <dvhart@linux.intel.com>
Cc: "Alan Cox" <alan@linux.intel.com>,
        "Tomoya MORINAGA" <tomoya.rohm@gmail.com>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "David Miller" <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <jeffrey.t.kirsher@intel.com>, <paul.gortmaker@windriver.com>,
        <jdmason@kudzu.us>, <netdev@vger.kernel.org>
X-OriginalArrivalTime: 16 Jan 2012 16:20:45.0440 (UTC) FILETIME=[CCCB5000:01CCD46A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> the tricky thing with embedded hw like this is that all devices might
> end up with the same, read-only filesystem, so storing the 
> mac on the FS
> and then loading it from there into the HW is... suboptimal.
> 
> Would be very nice if busybox had a command that would check the mac
> from each IF, and created the random mac from userspace 
> automatically...

Since multiple interfaces on a single system are unlikely
to be connected to the same LAN segment, it doesn't really
matter if they use same MAC address.

For a long time sun solaris systems used the same MAC
address (based on the system id) on all their ethernet
interfaces.

But yes, you don't want a 'random' number generator that
might give the same value for cloned systems.
You also really want a 'manufacturer id' for 'random address'
so that they can't collide with anuything using real addresses.

	David


