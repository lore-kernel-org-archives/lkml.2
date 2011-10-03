Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab1JCSwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 14:52:18 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28908 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1JCSwM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 14:52:12 -0400
MIME-Version: 1.0
Message-ID: <a4291ee6-2352-45af-acd9-4a87d1b897bd@default>
Date: Mon, 3 Oct 2011 11:51:53 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>, gregkh@suse.de
Cc: cascardo@holoscopio.com, rdunlap@xenotime.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: RE: [PATCH] staging: zcache: reduce tmem bucket lock contention
References: <1317306746-27072-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1317306746-27072-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6562.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet24.oracle.com [156.151.31.67]
X-CT-RefId: str=0001.0A02020A.4E8A0453.0100,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Sent: Thursday, September 29, 2011 8:32 AM
> To: gregkh@suse.de
> Cc: cascardo@holoscopio.com; Dan Magenheimer; rdunlap@xenotime.net; devel@driverdev.osuosl.org; linux-
> kernel@vger.kernel.org; Seth Jennings
> Subject: [PATCH] staging: zcache: reduce tmem bucket lock contention
> 
> tmem uses hash buckets each with their own rbtree and lock to
> quickly lookup tmem objects.  tmem has TMEM_HASH_BUCKETS (256)
> buckets per pool.  However, because of the way the tmem_oid is
> generated for frontswap pages, only 16 unique tmem_oids are being
> generated, resulting in only 16 of the 256 buckets being used.
> This cause high lock contention for the per bucket locks.
> 
> This patch changes SWIZ_BITS to include more bits of the offset.
> The result is that all 256 hash buckets are potentially used resulting in a
> 95% drop in hash bucket lock contention.
> 
> Based on v3.1-rc7
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Good catch Seth!

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
