Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1BNKad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 05:30:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55531 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab1BNKab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 05:30:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FZ2MzPDUIdrJGD+ECS3v2AnDK0Vu18MUn7m4kY1m8kV9eoIBVwegcyctBoSqDb6V78
         DRU0XFvAYKjXh8VPWCBB8jQBGa7plbhDlohnRpPN+HfJ1jYTuZS/AoiGUyyz410/zF/F
         +1C9V4Y/S+9PGSEzrBPUTCTQdWBhNErfrrBr0=
Date: Mon, 14 Feb 2011 11:30:26 +0100
From: Tejun Heo <tj@kernel.org>
To: Milan Broz <mbroz@redhat.com>
Cc: Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] loop: clear read-only flag in loop_clr_fd.
Message-ID: <20110214103026.GA18742@htj.dyndns.org>
References: <4D573BBB.6090200@redhat.com>
 <1297594735-5593-1-git-send-email-tm@tao.ma>
 <4D57E67E.1030707@redhat.com>
 <4D57F357.6060708@tao.ma>
 <4D580A8B.5050508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D580A8B.5050508@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 13, 2011 at 05:44:59PM +0100, Milan Broz wrote:
> On 02/13/2011 04:05 PM, Tao Ma wrote:
> > On 02/13/2011 10:11 PM, Milan Broz wrote:
> >> On 02/13/2011 11:58 AM, Tao Ma wrote:
> >>    
> >>> From: Tao Ma<boyu.mt@taobao.com>
> >>>
> >>> In 75f1dc0, we check bdev_read_only() from blkdev_get().
> >>> But the loop_clr_fd doesn't clear the read only flag.
> >>> What cause a error if we changing a loop device from
> >>> read only to writable.
> >>>      
> >> No, sorry, this is not proper/complete fix. It fixes it for loop
> >> (and even not completely - you are missing some error
> >> paths and ignoring autoclear mode where you have bdev NULL.)
> >> (And yes, I tried the same as workaround.)
> >>    
> > aha, sorry, I don't know you are more familiar with loop than me. ;)
> > I just did a quick test and sent the patch. So could you please tell me
> > a little more about how we use autoclear mode?

Umm... This was reported some time ago and patches were already
posted.  Milan, can you test whether the following two patches fix the
problems you're seeing?  Jens, what's the status of these patches?

  http://thread.gmane.org/gmane.linux.kernel/1090211/focus=1090666

Thanks.

-- 
tejun
