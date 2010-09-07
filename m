Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab0IGIbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 04:31:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42969 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab0IGIbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 04:31:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 7 Sep 2010 17:25:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minchan.kim\@gmail.com" <minchan.kim@gmail.com>,
        Mel Gorman <mel@csn.ul.ie>,
        "kosaki.motohiro\@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] big continuous memory allocator v2
Message-Id: <20100907172559.496554d8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <87occa9fla.fsf@basil.nowhere.org>
References: <20100907114505.fc40ea3d.kamezawa.hiroyu@jp.fujitsu.com>
	<87occa9fla.fsf@basil.nowhere.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Sep 2010 09:29:21 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> 
> > This is a page allcoator based on memory migration/hotplug code.
> > passed some small tests, and maybe easier to read than previous one.
> 
> Maybe I'm missing context here, but what is the use case for this?
> 

I hear some drivers want to allocate xxMB of continuous area.(camera?)
Maybe embeded guys can answer the question.

> If this works well enough the 1GB page code for x86, which currently
> only supports allocating at boot time due to the MAX_ORDER problem,
> could be moved over to runtime allocation. This would make
> GB pages a lot nicer to use.
> 
> I think it would still need declaring a large moveable
> area at boot right? (but moveable area is better than
> prereserved memory)
> 
Right.  

I think a main use-case is using allocation-at-init rather than boot
option. If modules can allocate a big chunk in __init_module() at boot,
boot option will not be necessary and it will be user friendly.
I think there are big free space before application starts running.

If on-demand loading of modules are required, it's safe to use MOVABLE zones.

> On the other hand I'm not sure the VM is really up to speed
> in managing such large areas.
> 

Thanks,
-Kame

