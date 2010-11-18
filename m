Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123Ab0KRPlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:41:44 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:37714 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab0KRPln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:41:43 -0500
X-Greylist: delayed 837 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Nov 2010 10:41:43 EST
Subject: Re: Question about nfs_page_async_flush assertion
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Peng Tao <lkml.bergwolf@gmail.com>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTimavN8px1k_Y65mFqsAsiLjgCh6vos22ZnZm+3Z@mail.gmail.com>
References: <AANLkTimavN8px1k_Y65mFqsAsiLjgCh6vos22ZnZm+3Z@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 10:27:43 -0500
Message-ID: <1290094063.3187.41.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 3 sum rcpts/h 9 sum msgs/h 3 total rcpts 1171 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 2D5179C054986001547690BE390C765DAE782CA5
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 3 total 459 max/h 7 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 18:53 +0800, Peng Tao wrote:
> Hi, all,
> 
> nfs_writepages calls into
> write_cache_pages()->nfs_writepages_callback()->nfs_do_writepage()->nfs_page_async_flush(),
> where it asserts BUG_ON(test_bit(PG_CLEAN, &req->wb_flags)).
> My question is: how do we guarantee the request has PG_CLEAN flag set?

We don't. We guarantee that the request has PG_CLEAN cleared, and that
is done when we dirty the page (see nfs_try_to_update_request()).

Cheers
  Trond

