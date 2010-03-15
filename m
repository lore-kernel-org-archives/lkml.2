Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965619Ab0COSJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 14:09:59 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:56919 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965510Ab0COSJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 14:09:58 -0400
Date: Mon, 15 Mar 2010 20:10:21 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux-kernel@vger.kernel.org,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] USB: f_mass_storage: dynamic buffers for better
 alignment
Message-ID: <20100315181020.GD3857@gandalf>
Reply-To: me@felipebalbi.com
References: <1268647795-4095-1-git-send-email-m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268647795-4095-1-git-send-email-m.nazarewicz@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 11:09:55AM +0100, Michal Nazarewicz wrote:
> "Static" buffers in fsg_buffhd structure (ie. fields which are arrays
> rather then pointers to dynamically allocated memory) are not aligned
> to any "big" power of two which may lead to poor DMA performance

not so true as you can add __attribute__ ((aligned(32))) to those.

> @@ -2747,13 +2746,18 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
>  
>  
>  	/* Data buffers cyclic list */
> -	/* Buffers in buffhds are static -- no need for additional
> -	 * allocation. */
>  	bh = common->buffhds;
> -	i = FSG_NUM_BUFFERS - 1;
> -	do {
> +	i = FSG_NUM_BUFFERS;
> +	for (i = FSG_NUM_BUFFERS;; ++bh) {

something like

for (i = 0; i < FSG_NUM_BUFFERS; i++, ++bh) {

wouldn't it do it ??

-- 
balbi
