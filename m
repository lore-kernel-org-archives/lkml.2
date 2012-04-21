Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab2DUC7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 22:59:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38648 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab2DUC7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 22:59:34 -0400
Subject: Re: [RFC][PATCH] introduce SIZE_MAX
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <20120420160337.479eeac0.akpm@linux-foundation.org>
Date: Fri, 20 Apr 2012 22:59:28 -0400
Cc: linux-kernel@vger.kernel.org, Alex Elder <elder@dreamhost.com>,
        David Airlie <airlied@linux.ie>, Pekka Enberg <penberg@kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <B2B99C3B-C1F5-4D7B-B73F-B64F296D23B6@gmail.com>
References: <1334809671-15288-1-git-send-email-xi.wang@gmail.com> <20120420160337.479eeac0.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 20, 2012, at 7:03 PM, Andrew Morton wrote:

> Will we need something for ssize_t also?

Did you mean something like SSIZE_MAX for replacing LONG_MAX?  That's
a good question since we have ssize_t.

I tried to grep `LONG_MAX' and `size'.  The only place I have found
so far is the following:

fs/xfs/xfs_aops.c:1247, in __xfs_get_blocks()

	if (mapping_size > LONG_MAX)
		mapping_size = LONG_MAX;

	bh_result->b_size = mapping_size;

Not sure if SSIZE_MAX works better here (`b_size' is size_t).

- xi
