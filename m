Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab2CAIGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 03:06:52 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40176 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab2CAIGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 03:06:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.204.145.70 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Message-ID: <4F4F2E16.5080703@openvz.org>
Date: Thu, 01 Mar 2012 12:06:46 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20120201 Iceape/2.0.14
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH resend] mm: drain percpu lru add/rotate page-vectors on
 cpu hot-unplug
References: <20120228193620.32063.83425.stgit@zurg> <20120229123818.61a61e9d.akpm@linux-foundation.org>
In-Reply-To: <20120229123818.61a61e9d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 28 Feb 2012 23:40:45 +0400
> Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
>
>> This cpu hotplug hook was accidentally removed in commit v2.6.30-rc4-18-g00a62ce
>> ("mm: fix Committed_AS underflow on large NR_CPUS environment")
>
> That was a long time ago - maybe we should leave it removed ;) I mean,
> did this bug(?) have any visible effect?  If so, what was that effect?

It's because cpu hotplug/unplug isn't widely used feature.
Visible effect -- some pages are borrowed in per-cpu page-vectors.
Truncate can deal with it, but these pages cannot be reused while this cpu is offline.
So this is like temporary memory leak.

>
> IOW, the changelog didn't give anyone any reason to apply the patch to
> anything!

Sorry, I'm just stuck in pile of patches. It seems I should stop and send them one by one.
This one isn't critical, so there no reasons for pushing it into stable branches.
