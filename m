Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab2LPDJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 22:09:27 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:59873 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab2LPDJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 22:09:26 -0500
Date: Sun, 16 Dec 2012 03:09:25 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fadvise: perform WILLNEED readahead in a workqueue
Message-ID: <20121216030925.GB28172@dcvr.yhbt.net>
References: <20121215005448.GA7698@dcvr.yhbt.net>
 <20121216024520.GH9806@dastard>
 <20121216030442.GA28172@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121216030442.GA28172@dcvr.yhbt.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Wong <normalperson@yhbt.net> wrote:
> Perhaps squashing something like the following will work?

Last hunk should've had a return before skip_ra:

--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -264,6 +266,10 @@ void wq_page_cache_readahead(struct address_space *mapping, struct file *filp,
 	req->nr_to_read = nr_to_read;
 
 	queue_work(readahead_wq, &req->work);
+
+	return;
+skip_ra:
+	fput(filp);
 }
 
 /*
-- 
Eric Wong
