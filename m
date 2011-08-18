Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab1HRMNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 08:13:18 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56573 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1HRMNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 08:13:15 -0400
Subject: Re: [PATCH] writeback: Per-block device
 bdi->dirty_writeback_interval and bdi->dirty_expire_interval.
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Kautuk Consul <consul.kautuk@gmail.com>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Thu, 18 Aug 2011 15:14:57 +0300
In-Reply-To: <20110818094824.GA25752@localhost>
References: <CAFPAmTSrh4r71eQqW-+_nS2KFK2S2RQvYBEpa3QnNkZBy8ncbw@mail.gmail.com>
	 <20110818094824.GA25752@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313669702.6607.24.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 17:48 +0800, Wu Fengguang wrote:
> > For example, the user might want to write-back pages in smaller
> > intervals to a block device which has a
> > faster known writeback speed.
> 
> That's not a complete rational. What does the user ultimately want by
> setting a smaller interval? What would be the problems to the other
> slow devices if the user does so by simply setting a small value
> _globally_?
> 
> We need strong use cases for doing such user interface changes.
> Would you detail the problem and the pains that can only (or best)
> be addressed by this patch?

Here is a real use-case we had when developing the N900 phone. We had
internal flash and external microSD slot. Internal flash is soldered in
and cannot be removed by the user. MicroSD, in contrast, can be removed
by the user.

For the internal flash we wanted long intervals and relaxed limits to
gain better performance.

For MicroSD we wanted very short intervals and tough limits to make sure
that if the user suddenly removes his microSD (users do this all the
time) - we do not lose data.

The discussed capability would be very useful in that case, AFAICS.

IOW, this is not only about fast/slow devices and how quickly you want
to be able to sync the FS, this is also about data integrity guarantees.

-- 
Best Regards,
Artem Bityutskiy

