Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2B0Ldy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 06:33:54 -0500
Received: from mx0.aculab.com ([213.249.233.131]:33563 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753306Ab2B0Ldw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 06:33:52 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: RFC: memory leak in udp_table_init
Date: Mon, 27 Feb 2012 11:33:07 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6E7D@saturn3.aculab.com>
In-Reply-To: <1330321223.3330.1.camel@edumazet-laptop>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: RFC: memory leak in udp_table_init
Thread-Index: Acz1Ejv0RHGgUOYHS+C08kH+8J+98wAMKD2g
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Eric Dumazet" <eric.dumazet@gmail.com>,
        "David Miller" <davem@davemloft.net>
Cc: <paul.gortmaker@windriver.com>, <tim.bird@am.sony.com>,
        <kuznet@ms2.inr.ac.ru>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
X-OriginalArrivalTime: 27 Feb 2012 11:33:08.0045 (UTC) FILETIME=[93EF4FD0:01CCF543]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > [PATCH] mm: add a low limit to alloc_large_system_hash
> > 
> > I think you should just use zero as the default minimum for all
> > call sites except this UDP case we are trying to fix.
> > 
> > For example I see you used 16 for kernel/pid.c
> > 
> > Let's not try to do unrelated changes like that now, we can do such
> > tweaks later.
> 
> It was to match the comment we have few lines above :
> 
> /*
>  * The pid hash table is scaled according to the amount of memory in
the
>  * machine.  From a minimum of 16 slots up to 4096 slots at one
gigabyte or
>  * more.
>  */

These large hash tables are, IMHO, an indication that the
algorithm used is, perhaps, suboptimal.

Not least of the problems is actually finding a suitable
(and fast) hash function that will work with the actual
real-life data.

The pid table is a good example of something where a hash
table is unnecessary.
Linux should steal the code I put into NetBSD :-)

	David


