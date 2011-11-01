Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab1KAP7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 11:59:53 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46435 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1KAP7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 11:59:52 -0400
Date: Tue, 1 Nov 2011 08:59:45 -0700
From: Tejun Heo <htejun@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: trisha yad <trisha1march@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Issue with core dump
Message-ID: <20111101155945.GQ18855@google.com>
References: <CAGr+u+zkPiZpGefstcbJv_cj929icWKXbqFy1uR22Hns1hzFeQ@mail.gmail.com>
 <20111101152320.GA30466@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101152320.GA30466@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 01, 2011 at 04:23:20PM +0100, Oleg Nesterov wrote:
> Whatever we do, we can't "stop" other threads at the time when
> thread 'a' traps. All we can do is to try to shrink the window.

Yeah, "at the time" can't even be defined preciesly.  Order of
operation isn't clearly defined in absence of synchronization
constructs.  In the described example, there's unspecified amount of
time (or cycles rather) between the load of the global variable and
the thread faulting.  Anything could have happened inbetween no matter
how immediate core dump was.

As long as we're reasonably immediate, which I think we already are, I
don't think there's much which needs to be changed.

Thanks.

-- 
tejun
