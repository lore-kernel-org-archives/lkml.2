Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab1HaTrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 15:47:06 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:39836 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1HaTrC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 15:47:02 -0400
MIME-Version: 1.0
Message-ID: <6e0e7950-0c91-4bb3-929b-3853fa95e63d@default>
Date: Wed, 31 Aug 2011 12:46:43 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>, gregkh@suse.de
Cc: devel@driverdev.osuosl.org, ngupta@vflare.org, cascardo@holoscopio.com,
        rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Subject: RE: [PATCH 0/3] staging: zcache: xcfmalloc support
References: <1314801641-15059-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1314801641-15059-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090202.4E5E8FAF.017B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patchset introduces a new memory allocator for persistent
> pages for zcache.  The current allocator is xvmalloc.  xvmalloc
> has two notable limitations:
> * High (up to 50%) external fragmentation on allocation sets > PAGE_SIZE/2
> * No compaction support which reduces page reclaimation
> 
> xcfmalloc seeks to fix these issues by using scatter-gather model that
> allows for cross-page allocations and relocatable data blocks.
> 
> In tests, with pages that only compress to 75% of their original
> size, xvmalloc had an effective compression (pages stored / pages used by the
> compressed memory pool) of ~95% (~20% lost to fragmentation). Almost nothing
> was gained by the compression in this case. xcfmalloc had an effective
> compression of ~77% (about ~2% lost to fragmentation and metadata overhead).

Hi Seth --

Do you have any data comparing xcfmalloc vs xvmalloc for
compression ratio and/or performance (cycles to compress
or decompress different pages) on a wide(r) range of data?
Assuming xcfmalloc isn't "always better", maybe it would
be best to allow the algorithm to be selectable?  (And
then we would also need to decide the default.)

(Hopefully Nitin will have a chance to comment, since he
has much more expertise in compression than I do.)

Thanks,
Dan
