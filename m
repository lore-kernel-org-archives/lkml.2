Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab1EKPis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:38:48 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:42111 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab1EKPip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:38:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ceHkXSITnY/INtfe+YJVjRg125vXy+2t7jgroKz/vWpsjxS43Lz/I2cV9OpMbehL+G
         teR9kWACmFPP9WYgS3SVrH4YCB+4QZbHYRx8S2VT5nz9BBWrOxoT4pjMQJ8nfHbaMEUr
         5P9gROWmEOA2hnBD4RFi5hUrEnftT3rtgIOyE=
Subject: Re: [PATCH] blk-throttle: fix typos on struct throtl_grp init code
From: Namhyung Kim <namhyung@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
In-Reply-To: <20110511142853.GE31633@redhat.com>
References: <20110511130732.GB31633@redhat.com>
	 <1305120045-5111-1-git-send-email-namhyung@gmail.com>
	 <20110511133033.GD31633@redhat.com> <1305123242.1561.20.camel@leonhard>
	 <20110511142853.GE31633@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 23:38:48 +0900
Message-ID: <1305124728.1561.24.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-05-11 (수), 10:28 -0400, Vivek Goyal:
> On Wed, May 11, 2011 at 11:14:02PM +0900, Namhyung Kim wrote:
> > 2011-05-11 (수), 09:30 -0400, Vivek Goyal:
> > > On Wed, May 11, 2011 at 10:20:45PM +0900, Namhyung Kim wrote:
> > > > s/td/tg/
> > > 
> > > I think jens would like to have little more changelog than that.
> > > 
> > 
> > OK, let me clarify this first: My first patch was trivial but second one
> > seems not. AFAICS it could affect when the bps/iops bandwidth change
> > applies - maybe delayed to next @tg->disptime? - if there are concurrent
> > cgroup init and limit change tasks, right? Or do you have something need
> > to be included in the changelog?
> 
> Just say that when a new group is initialized, set tg->limits_changed =
> false instead of setting td->limits_changed to false.
> 
> We do memset 0 on all newly allocated objects to this might not be
> required at all. 
> 
> So how about just getting rid of td->limits_changed assignments and
> not do explicit tg->limits_changed as that is implicit in zeroing of
> newly allocated object.
> 
> Thanks
> Vivek
> 

Sounds good to me. I'll cook a new patch :)

Thanks.


-- 
Regards,
Namhyung Kim


