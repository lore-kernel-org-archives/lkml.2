Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab2E1XR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 19:17:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43210 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2E1XR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 19:17:26 -0400
Date: Tue, 29 May 2012 08:17:17 +0900
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        axboe@kernel.dk, paul.gortmaker@windriver.com
Subject: Re: [PATCH 3/3] block: convert elevator to generic rb tree code
Message-ID: <20120528231717.GB20954@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1337979461-19654-1-git-send-email-koverstreet@google.com>
 <1337979461-19654-4-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337979461-19654-4-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 01:57:41PM -0700, Kent Overstreet wrote:
> Change-Id: I676968e201f0de9a0d0a7813e2fcc6873343e8c3
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>

You know what I was gonna complain about here, right?  :)

>  struct request *elv_rb_find(struct rb_root *root, sector_t sector)
>  {
> -	struct rb_node *n = root->rb_node;
> -	struct request *rq;
> -
> -	while (n) {
> -		rq = rb_entry(n, struct request, rb_node);
> +	struct request search = { .__sector = sector };

This is dangerous.  You can't put things like struct request on stack.
It might look like it's working ok on the tested setup but archs
differ in stack pressure and more importantly people may add
arbitrarily sized fields, including debugging stuff, to struct
request.  So, no, please don't do that.

Thanks.

-- 
tejun
