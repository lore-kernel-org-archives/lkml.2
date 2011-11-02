Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab1KBLco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 07:32:44 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:52134 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751655Ab1KBLcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 07:32:42 -0400
Date: Wed, 2 Nov 2011 11:30:31 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: trisha yad <trisha1march@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-mm <linux-mm@kvack.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <htejun@gmail.com>
Subject: Re: Issue with core dump
Message-ID: <20111102113030.GE22462@linux-mips.org>
References: <CAGr+u+zkPiZpGefstcbJv_cj929icWKXbqFy1uR22Hns1hzFeQ@mail.gmail.com>
 <20111101152320.GA30466@redhat.com>
 <CAGr+u+wgAYVWgdcG6o+6F0mDzuyNzoOxvsFwq0dMsR3JNnZ-cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGr+u+wgAYVWgdcG6o+6F0mDzuyNzoOxvsFwq0dMsR3JNnZ-cA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 12:03:39PM +0530, trisha yad wrote:

> Thanks all for your answer.
> 
> In loaded embedded system the time at with code hit do_user_fault()
> and core_dump_wait() is bit
> high, I check on my  system it took 2.7 sec. so it is very much
> possible that core dump is not correct.
> It  contain global value updated.
> 
> So is it possible at time of send_signal() we can stop modification of
> faulty thread memory ?

On existing hardware it is impossible to take a consistent snapshot of a
multi-threaded application at the time of one thread faulting.

A software simulator can handle this sort of race condition but of course
this approach has other disadvantages.

  Ralf
