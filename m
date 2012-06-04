Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab2FDNYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:24:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51537 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab2FDNYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:24:03 -0400
Message-ID: <4FCCB6E4.7020708@kernel.dk>
Date: Mon, 04 Jun 2012 15:23:48 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3.5-rc1] blkcg: fix blkg_alloc() failure path
References: <20120604062100.GA2843@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120604062100.GA2843@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 08:21 AM, Tejun Heo wrote:
> When policy data allocation fails in the middle, blkg_alloc() invokes
> blkg_free() to destroy the half constructed blkg.  This ends up
> calling pd_exit_fn() on policy datas which didn't go through
> pd_init_fn().  Fix it by making blkg_alloc() call pd_init_fn()
> immediately after each policy data allocation.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> ---
> Jens, this was posted as part of "block: implement per-blkg request
> allocation" patchset[1] but should be applied as fix on v3.5-rc1.

Applied for 3.5 current, thanks.

-- 
Jens Axboe

