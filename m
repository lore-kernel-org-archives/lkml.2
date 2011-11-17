Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab1KQIgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 03:36:22 -0500
Received: from mga14.intel.com ([143.182.124.37]:28449 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab1KQIgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 03:36:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,524,1315206000"; 
   d="scan'208";a="76082976"
Subject: Re: [PATCH] dmaengine/ste_dma40: support pm in dma40
From: Vinod Koul <vinod.koul@intel.com>
To: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
In-Reply-To: <20111117064001.GA17619@bnru01>
References: <1321425003-12062-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
	 <1321441623.1516.168.camel@vkoul-udesk3> <20111117050443.GA6256@bnru01>
	 <1321507432.1516.176.camel@vkoul-udesk3>  <20111117064001.GA17619@bnru01>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 14:01:51 +0530
Message-ID: <1321518712.1516.181.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 12:10 +0530, Narayanan G wrote:
> On Thu, Nov 17, 2011 at 06:23:52 +0100, Vinod Koul wrote:
> > runtime pm manages the device power management. It will call your
> > suspend/resume callbacks when your device is idle/active and manages the
> > device usage for you.
> > Within your device you need to do your own management, which should be
> > linked to channel being active. You should not club the two.
> > 
> > I am not sure if the clock framework can help you on this
> 
> Instead of switching on and off eventlines very frequently, I'll
> do it in the runtime_suspend() and runtime_resume(), so that it
> looks more neat and can get away with these usage counters.
> I will re-work and submit a new version of this patch.
if you want to do your clock switching per channel based then you cant
do in runtime_resume/suspned code which seems to be approach. As I said
its device specific, so if you move all to these callbacks then you can
easily eliminate the mess in patch right now and make it cleaner.


-- 
~Vinod

