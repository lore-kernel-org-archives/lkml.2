Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab2AXTql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 14:46:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab2AXTqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 14:46:40 -0500
Date: Tue, 24 Jan 2012 14:46:35 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tejun@google.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH UPDATED 14/16] blkcg: don't allow or retain configuration
 of missing devices
Message-ID: <20120124194635.GD17291@redhat.com>
References: <1327360193-24679-1-git-send-email-tj@kernel.org>
 <1327360193-24679-15-git-send-email-tj@kernel.org>
 <20120124193058.GC421@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124193058.GC421@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 11:30:58AM -0800, Tejun Heo wrote:

[..]
> +
> +	/*
> +	 * If queue was bypassing, we should retry.  Do so after a short
> +	 * msleep().  It isn't strictly necessary but queue can be
> +	 * bypassing for some time and it's always nice to avoid busy
> +	 * looping.
> +	 */
> +	if (ret == -EBUSY) {
> +		msleep(10);
> +		return restart_syscall();
> +	}
>  	return ret;

Thanks. This one looks better.

Vivek
