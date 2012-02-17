Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab2BQVdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 16:33:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab2BQVdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 16:33:19 -0500
Date: Fri, 17 Feb 2012 16:33:13 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH 7/9] block: implement bio_associate_current()
Message-ID: <20120217213313.GG26620@redhat.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329431878-28300-8-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 02:37:56PM -0800, Tejun Heo wrote:

[..]
> This patch implements bio_associate_current() which associates the
> specified bio with %current.  The bio will record the associated ioc
> and blkcg at that point and block layer will use the recorded ones
> regardless of which task actually ends up issuing the bio.  bio
> release puts the associated ioc and blkcg.

How about storing blkcg information in io_context instead of bio. We will
have less copies of bio pointers and I think logically it makes sense.

Thanks
Vivek
