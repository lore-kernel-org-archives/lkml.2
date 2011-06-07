Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab1FGHma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 03:42:30 -0400
Received: from mail.perches.com ([173.55.12.10]:2592 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab1FGHm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 03:42:29 -0400
Subject: Re: [Cocci] [RFC] Convert "resource->end - resource->start + 1" to
 resource_size(resource) via coccinelle
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia@diku.dk>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>, cocci <cocci@diku.dk>,
        vinod.koul@intel.com, dan.j.williams@intel.com,
        Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1106070741510.18329@ask.diku.dk>
References: <201106061349.00474.hartleys@visionengravers.com>
	 <1307397174.4994.26.camel@Joe-Laptop>
	 <Pine.LNX.4.64.1106070706000.18329@ask.diku.dk>
	 <1307424738.1651.7.camel@Joe-Laptop>
	 <Pine.LNX.4.64.1106070741510.18329@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 00:42:27 -0700
Message-ID: <1307432547.1651.11.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 07:42 +0200, Julia Lawall wrote:
> On Mon, 6 Jun 2011, Joe Perches wrote:
> > Cocci already handles the parens case
> > "(foo->end-foo->start)+1"
> If you put parentheses, it will consider removing them.  But I don't think 
> it would go the other way around.

It does.

$ spatch -very_quiet -sp_file resource.cocci t2.c
--- t2.c	2011-06-07 00:37:48.000000000 -0700
+++ /tmp/cocci-output-3529-9bb101-t2.c	2011-06-07 00:38:31.000000000
-0700
@@ -12,7 +12,7 @@ void test_resource(void)
 {
 	int i;
 	for (i = 0; i < ARRAY_SIZE(array); i++) {
-		if ((p[i].end - p[i].start) + 1 > 0x12345)
+		if (resource_size(p) > 0x12345)
 			printk(KERN_CRIT "Some failure\n");
 	}
 }


