Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966195Ab2EOSYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:24:37 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30276 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965150Ab2EOSYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:24:21 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6712"; a="188906584"
Message-ID: <3a028a6583c7fac372c8711930fc1874.squirrel@www.codeaurora.org>
In-Reply-To: <1334730332-22244-1-git-send-email-svenkatr@ti.com>
References: <1334730332-22244-1-git-send-email-svenkatr@ti.com>
Date: Tue, 15 May 2012 21:24:21 +0300 (IDT)
Subject: Re: [RFC PATCH 00/11] [FS, MM, block,
      MMC]: eMMC High Priority Interrupt Feature
From: "Konstantin Dorfman" <kdorfman@codeaurora.org>
To: "Venkatraman S" <svenkatr@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        arnd.bergmann@linaro.org, cjb@laptop.org, alex.limberg@sandisk.com,
        ilan.smith@sandisk.com, lporzio@micron.com,
        "Venkatraman S" <svenkatr@ti.com>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, April 18, 2012 9:25 am, Venkatraman S wrote:
Hello,

> a) At the top level, some policy decisions have to be made on what is
> worth preempting for.
> 	This implementation uses the demand paging requests and swap
> read requests as potential reads worth preempting an ongoing long write.
> 	This is expected to provide improved responsiveness for smarphones
> with multitasking capabilities - example would be launch a email
> application
> while a video capture session (which causes long writes) is ongoing.
> b) At the block handler, the higher priority request should be queued
>   ahead of the pending requests in the elevator
> c) At the MMC block and core level, transactions have to executed to
> enforce the rules of the MMC spec and make a reasonable tradeoff if the
> ongoing command is really worth preempting. (For example, is it too close
> to completing already ?).

Do you have some profiling information (on real or synthetic scenarios)
that may prove/show improvement in read latency for your design?

It could be useful to use blktrace engine with some post processing to get
per request (or per block) latency.

Also you can gather some statistics about how often demand paging and swap
read requests occurs during typical user scenarios.

Without such statistical analysis we are risking to do hard work with zero
benefits.
Does this make sense?

Thanks,
Kostya
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum



