Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557Ab1IOMmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:42:46 -0400
Received: from smtp.citrix.com ([66.165.176.89]:3997 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933522Ab1IOMku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:40:50 -0400
X-IronPort-AV: E=Sophos;i="4.68,387,1312171200"; 
   d="scan'208";a="17185364"
From: David Vrabel <david.vrabel@citrix.com>
To: xen-devel@lists.xensource.com
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org,
        "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH 0/6] xen: don't call vmalloc_sync_all() when mapping foreign pages
Date: Thu, 15 Sep 2011 13:40:05 +0100
Message-ID: <1316090411-22608-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of pages avoids the need to call vmalloc_sync_all() when
mapping foreign pages.  Two new functions are adding for mapping
foreign pages onto RAM pages instead of vmalloc space.

This does waste a page of RAM for each mapped page.  In the future a
ballooned page could be used instead (once the API for getting a
ballooned page with the right GFP flags is available).

David

