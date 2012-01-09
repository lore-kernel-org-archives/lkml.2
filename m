Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab2AIQl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 11:41:59 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:45819 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932178Ab2AIQlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 11:41:55 -0500
Date: Mon, 9 Jan 2012 08:41:48 -0800
From: Tejun Heo <tj@kernel.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] block: introduce BIO_IN_FLIGHT flag
Message-ID: <20120109164148.GB21732@google.com>
References: <1324996113-1837-1-git-send-email-namhyung@gmail.com>
 <1324996113-1837-2-git-send-email-namhyung@gmail.com>
 <20120109015628.GB16360@mtj.dyndns.org>
 <4F0A57A7.4070508@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0A57A7.4070508@lge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 09, 2012 at 11:57:43AM +0900, Namhyung Kim wrote:
> I understand your concerns. However, the blktrace cannot get
> bio->bi_flags info in its current form AFAIK. Doing it will require
> extending struct blk_io_trace and it'll cause a compatibility issue,
> I guess.

Umm?  Why can't blk_add_trace_bio_complete() look at the flags (or
whatever other states) to decide to fire off BLK_TA_COMPLETE or not?
What's the difference?  No userland visible change is necessary at
all.  Just make blktrace.c do the right thing.  Am I missing
something?

Thanks.

-- 
tejun
