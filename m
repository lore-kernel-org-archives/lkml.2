Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab1JSQ7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:59:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab1JSQ7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:59:38 -0400
Date: Wed, 19 Oct 2011 12:59:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com,
        rni@google.com
Subject: Re: [PATCH 02/10] block: fix genhd refcounting in
 blkio_policy_parse_and_set()
Message-ID: <20111019165932.GH1140@redhat.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-3-git-send-email-tj@kernel.org>
 <20111019132657.GA1140@redhat.com>
 <20111019162902.GA25124@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019162902.GA25124@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 09:29:02AM -0700, Tejun Heo wrote:
> Hello,
> 
> On Wed, Oct 19, 2011 at 09:26:57AM -0400, Vivek Goyal wrote:
> > What's the advantage of collapsing blkio_check_dev_num(). Why not put the
> > reference to gendisk in this function before returning either success or
> > failure.
> 
> Heh, at first, I just thought there would be something which depends
> on disk still being around in the code path as unsynchronized one time
> check upfront doesn't really guarantee anything; then, I realized
> there was nothing, but I still left it like that because I personally
> think blkio_check_dev_num() w/o surrounding exclusion is a bad
> interface.  It's at best opportunistic and likely to mislead people
> into believing that there's some magical implied synchronization.
> 
> Also, I'm planning on cleaning up synchronization around iocg and for
> it to work properly, it'll be necessary to do proper ref counting and
> removal on release anyway.

Are you trying to tie the rules with actual presence of device. Current
model is that we just check for a valid device while somebody is
specifying the rule. After that device can go away and rule can still
be there.  We are just trying to make sure that when you are putting
the rule, atleast at that time device is present.

Thanks
Vivek
