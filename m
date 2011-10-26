Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab1JZTzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 15:55:14 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54365 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab1JZTzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 15:55:12 -0400
Date: Wed, 26 Oct 2011 12:55:06 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/13] block, cfq: unlink cfq_io_context's immediately
Message-ID: <20111026195506.GD24261@google.com>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
 <1319593719-19132-11-git-send-email-tj@kernel.org>
 <20111026194857.GF355@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111026194857.GF355@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 26, 2011 at 03:48:57PM -0400, Vivek Goyal wrote:
> > +		ioc_release_depth_inc(cic->q);
> > +		cic->exit(cic);
> > +		cic->release(cic);
> > +		ioc_release_depth_dec(cic->q);
> 
> cic->release(cic) can free the cic? Are we accessing cic after freeing it
> up in ioc_release_depth_dec(cic->q);

As cic is RCU freed and we're running w/ irq disabled, this shouldn't
blow up, but yeah, I'll update it to use local variable instead.

Thanks.

-- 
tejun
