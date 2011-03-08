Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab1CHPEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:04:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118Ab1CHPEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:04:07 -0500
Date: Tue, 8 Mar 2011 10:03:57 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Justin TerAvest <teravest@google.com>,
        "ctalbott@google.com" <ctalbott@google.com>,
        "guijianfeng@cn.fujitsu.com" <guijianfeng@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blk-cgroup: Lower minimum weight from 100 to 10.
Message-ID: <20110308150357.GE27455@redhat.com>
References: <1299538394-9669-1-git-send-email-teravest@google.com>
 <4D763F07.1070103@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D763F07.1070103@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 03:36:55PM +0100, Jens Axboe wrote:
> On 2011-03-07 23:53, Justin TerAvest wrote:
> > We've found that we still get good, useful isolation at weights this
> > low. I'd like to adjust the minimum so that any other changes can take
> > these values into account.
> 
> Justin, this looks fine to me if Vivek agrees. You did not sign-off on
> the patch though, so I can't apply it yet. Please re-send with the ack
> from Vivek added and your signed-off-by as well.

The primary reason I am fine with wider weight range because there are
many situations where we just don't get effective 10 times service
differentiation for various reasons like workload don't seem to be
active at the service tree at the same time or if we decide to swith
off idling on faster storage etc.

So because of this leaky nature of service differentiation, it might help to
have a wider range of allowed weights.

Thanks
Vivek
