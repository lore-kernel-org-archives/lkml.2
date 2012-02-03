Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab2BCAlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 19:41:51 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50222 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab2BCAls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 19:41:48 -0500
MIME-Version: 1.0
In-Reply-To: <20120203104453.8438182da9f365c24d3c2128@canb.auug.org.au>
References: <20120202144516.11b33e667a7cbb8d85d96226@canb.auug.org.au>
	<4F2AD4DE.7040508@xenotime.net>
	<20120203104453.8438182da9f365c24d3c2128@canb.auug.org.au>
Date: Thu, 2 Feb 2012 16:41:47 -0800
Message-ID: <CAN8TOE9tPypqedF4HUnNPLO9pXbKig3oij6qO6BnytACGTWGwQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Feb 2 (fs/jffs2)
From: Brian Norris <computersforpeace@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 2, 2012 at 3:44 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Thu, 02 Feb 2012 10:24:30 -0800 Randy Dunlap <rdunlap@xenotime.net> wrote:
>>
>> fs/jffs2/*.c still contains uses of ->read etc. instead of using
>> mtd_read() etc.
>>
>> fs/jffs2/read.c:36:8: error: 'struct mtd_info' has no member named 'read'
>> fs/jffs2/read.c:112:8: error: 'struct mtd_info' has no member named 'read'
>> fs/jffs2/nodemgmt.c:669:8: error: 'struct mtd_info' has no member named 'read'
>> fs/jffs2/readinode.c:83:9: error: 'struct mtd_info' has no member named 'read'
>> fs/jffs2/readinode.c:676:9: error: 'struct mtd_info' has no member named 'read'
>> fs/jffs2/readinode.c:954:8: error: 'struct mtd_info' has no member named 'read'
>> fs/jffs2/readinode.c:1040:9: error: 'struct mtd_info' has no member named 'read'
>> fs/jffs2/readinode.c:1216:8: error: 'struct mtd_info' has no member named 'read'
>> fs/jffs2/readinode.c:1275:10: error: 'struct mtd_info' has no member named 'read'
>> fs/jffs2/scan.c:286:8: error: 'struct mtd_info' has no member named 'read'
>> fs/jffs2/gc.c:590:8: error: 'struct mtd_info' has no member named 'read'
>> fs/jffs2/gc.c:894:10: error: 'struct mtd_info' has no member named 'read'
>> fs/jffs2/gc.c:977:9: error: 'struct mtd_info' has no member named 'read'
>
> They were probably missed because they use the jffs2_flash_read() macro
> in fs/jffs2/os-linux.h

I just sent a patch that fixes this, FYI. If Artem and Randy ACK it,
it'll probably go into l2-mtd-2.6.git.

Brian
