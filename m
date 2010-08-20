Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab0HTFvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 01:51:42 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:41695 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750839Ab0HTFvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 01:51:39 -0400
From: Con Kolivas <kernel@kolivas.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] writeback: remove the internal 5% low bound on dirty_ratio
Date: Fri, 20 Aug 2010 15:50:54 +1000
User-Agent: KMail/1.9.9
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, riel@redhat.com, david@fromorbit.com, hch@lst.de,
        axboe@kernel.dk
References: <20100820032506.GA6662@localhost> <20100820131249.5FF4.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100820131249.5FF4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201008201550.54164.kernel@kolivas.org>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010 02:13:25 pm KOSAKI Motohiro wrote:
> > The dirty_ratio was silently limited to >= 5%. This is not a user
> > expected behavior. Let's rip it.
> >
> > It's not likely the user space will depend on the old behavior.
> > So the risk of breaking user space is very low.
> >
> > CC: Jan Kara <jack@suse.cz>
> > CC: Neil Brown <neilb@suse.de>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
>
> Thank you.
> 	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

I have tried to do this in the past, and setting this value to 0 on some 
machines caused the machine to come to a complete standstill with small 
writes to disk. It seemed there was some kind of "minimum" amount of data 
required by the VM before anything would make it to the disk and I never 
quite found out where that blockade occurred. This was some time ago (3 years 
ago) so I'm not sure if the problem has since been fixed in the VM since 
then. I suggest you do some testing with this value set to zero before 
approving this change.

Regards,
--
-ck
