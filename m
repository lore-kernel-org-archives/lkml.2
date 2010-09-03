Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab0ICANm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 20:13:42 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53417 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab0ICANl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 20:13:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causeshibernation to hang
Cc: kosaki.motohiro@jp.fujitsu.com, "M. Vefa Bicakci" <bicave@superonline.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <201009022224.59313.rjw@sisk.pl>
References: <201009022157.18561.rjw@sisk.pl> <201009022224.59313.rjw@sisk.pl>
Message-Id: <20100903085756.B657.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  3 Sep 2010 09:13:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > > > Like in the patch below, perhaps?
> > > 
> > > Looks like fine. but I have one question. hibernate_preallocate_memory() call
> > > preallocate_image_memory() two times. Why do you only care latter one?
> > > former one seems similar risk.
> > 
> > The first one is mandatory, ie. if we can't allocate the requested number of
> > pages at this point, we fail the entire hibernation.  In that case the
> > performance hit doesn't matter.
> 
> IOW, your patch at http://lkml.org/lkml/2010/9/2/262 is still necessary to
> protect against the infinite loop in that case.

As far as I understand, we need distinguish two allocation failure.
  1) failure because no enough memory
	-> yes, hibernation should fail
 2) failure because already allocated enough lower zone memory
	-> why should we fail?

If the system has a lot of memory, scenario (2) is happen frequently than (1).
I think we need check alloc_highmem and alloc_normal variable and call
preallocate_image_highmem() again instead preallocate_image_memory()
if we've alread allocated enough lots normal memory.

nit?



