Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab1BNOIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 09:08:06 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36771 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab1BNOIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 09:08:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ChqOrP68cDdg1UByKrWlpK/DxAq/kI0hKNDKBNxRP7bcod+4dL0vBahIa9I4yqVNAu
         o5wwUK5EV0dk+j9HGc72Gvrr4PC3iY8jS1Lzz16wmTEjkAt8+YhvSiDkWRoUTysP1+ep
         lg+ySef+e+I4GlUxuz4VjDPeOPT/cOwY5gHb4=
Date: Mon, 14 Feb 2011 15:07:55 +0100
From: Tejun Heo <tj@kernel.org>
To: Milan Broz <mbroz@redhat.com>
Cc: Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        device-mapper development <dm-devel@redhat.com>
Subject: Re: [PATCH] loop: clear read-only flag in loop_clr_fd.
Message-ID: <20110214140755.GL18742@htj.dyndns.org>
References: <4D573BBB.6090200@redhat.com>
 <1297594735-5593-1-git-send-email-tm@tao.ma>
 <4D57E67E.1030707@redhat.com>
 <4D57F357.6060708@tao.ma>
 <4D580A8B.5050508@redhat.com>
 <20110214103026.GA18742@htj.dyndns.org>
 <4D591664.6090203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D591664.6090203@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Milan.

On Mon, Feb 14, 2011 at 12:47:48PM +0100, Milan Broz wrote:
> With patch below (loop cannot be built as module) it fixes the loop problem.

Okay.

> But it doesn't fix the read-only snapshot issue and I guess there will be
> the same problem with read-only MD code too.
> (so the 2) issue here https://lkml.org/lkml/2011/2/12/209).
> 
> If the call is changed intentionally, we have to fix unconditional blkdev open
> calls with read-write flag in this code.
> Before doing that I would like to know if it was intentional change or not...

Yeap, the change was intentional.  It was part of effort to make bdev
usages more consistent as before there was no mechanism enforcing ro.
It's still problematic as bdev users can clear ro without consulting
the actual device driver.  Device driver's ->open() is called w/ ro
flag but the resulting bdev can be used rw.  I wanted to remove that
too but filesystems depend on it so maybe later.

Thanks.

-- 
tejun
