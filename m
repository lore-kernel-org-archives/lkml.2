Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab0IUIMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 04:12:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55398 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab0IUIMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 04:12:25 -0400
Message-ID: <562d0c45d5a10d80c3583c2fe1c318c7.squirrel@www.firstfloor.org>
In-Reply-To: <20100921080459.GA29540@localhost>
References: <20100921022112.GA10336@localhost>
    <20100921061310.GA11526@localhost>
    <20100921162316.3C03.A69D9226@jp.fujitsu.com>
    <31aed4ad96866a97dc791186303c5719.squirrel@www.firstfloor.org>
    <20100921080459.GA29540@localhost>
Date: Tue, 21 Sep 2010 10:12:23 +0200
Subject: Re: Problem with debugfs
From: "Andi Kleen" <andi@firstfloor.org>
To: "Wu Fengguang" <fengguang.wu@intel.com>
Cc: "Andi Kleen" <andi@firstfloor.org>,
        "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
        "Kenneth" <liguozhu@huawei.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org,
        "Naoya Horiguchi" <n-horiguchi@ah.jp.nec.com>,
        "linux-mm" <linux-mm@kvack.org>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> Thanks for the report.  Did this show up as a real bug? What's your
> use case? Or is it a theoretic concern raised when doing code review?

I assume it was code review, right?

> Yeah the hwpoison_filter_flags_* values are not referenced strictly
> safe to concurrent updates. I didn't care it because the typical usage
> is for hwpoison test tools to _first_ echo hwpoison_filter_flags_*
> values into the debugfs and _then_ start injecting hwpoison errors.
> Otherwise you cannot get reliable test results. The updated value is
> guaranteed to be visible because there are file mutex UNLOCK and page
> LOCK operations in between.

Sorry that's not true -- all the x86 memory ordering constraints only
apply to a single CPU or same address.

But I agree it doesn't really matter for a debugging feature
like this.

So unless there's a very simple fix I would be inclined to leave
it alone, perhaps with a comment added. Comments?

-Andi

