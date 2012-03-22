Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab2CVKAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 06:00:52 -0400
Received: from metasoft.pl ([195.149.224.191]:58407 "EHLO smtp.metasoft.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598Ab2CVKAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 06:00:50 -0400
X-clamdmail: clamdmail 0.18a
Message-ID: <4F6AF845.9070209@metasoft.pl>
Date: Thu, 22 Mar 2012 11:00:37 +0100
From: Rafal Prylowski <prylowski@metasoft.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Ryan Mallon <rmallon@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
References: <4F683B36.8090101@metasoft.pl> <4F6A78ED.3050403@gmail.com>
In-Reply-To: <4F6A78ED.3050403@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-22 01:57, Ryan Mallon wrote:
> I haven't looked through the patch yet, since I'm waiting on more
> information from Mika and Hartley's testing.
> 
> However, the commit log doesn't tell me why we want this change. Is it a
> performance improvement? If so, do you have some numbers that we can
> paste into the commit log?

In principle, using double buffering should be faster than using only
one buffer and disabling/enabling channel each time. But my measurements
doesn't show any significant change.

The real reason for this change is that current code is not 100% reliable
in IDE-DMA (I'm planning to submit ep93xx ide driver to linux-ide soon).
Although using only one buffer and DONE interrupt is simple, surprisingly
we can get interrupt when M2M DMA is in DMA_BUF_ON and DMA_STALL state.
If we disable the channel at this moment, we end with ata timeout.
