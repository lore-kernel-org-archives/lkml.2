Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab1EFSHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 14:07:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756636Ab1EFSHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 14:07:52 -0400
Date: Fri, 6 May 2011 20:06:46 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: "Figo.zhang" <figo1802@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, mel@csn.ul.ie,
        kamezawa.hiroyu@jp.fujisu.com, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH]mm/page_alloc.c: no need del from lru
Message-ID: <20110506180646.GF6330@random.random>
References: <1304694099.2450.3.camel@figo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304694099.2450.3.camel@figo-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, May 06, 2011 at 11:01:21PM +0800, Figo.zhang wrote:
> 
> split_free_page() the page is still free page, it is no need del from lru.

This is in the buddy freelist, see the other list_add in
page_alloc.c. It's not the lru as in release_pages. I see little
chance that if this was wrong it could go unnoticed so long without
major mm corruption reported. Removing it also should result in heavy
mm corruption.

Thanks,
Andrea
