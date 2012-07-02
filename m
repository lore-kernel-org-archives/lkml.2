Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab2GBKQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:16:22 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54283 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929Ab2GBKQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:16:20 -0400
Date: Mon, 2 Jul 2012 12:16:08 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] Potential fix for leapsecond caused futex
 related load spikes
Message-ID: <20120702101606.GA16008@localhost.localdomain>
References: <4FF06CAB.9020800@redhat.com>
 <4FF08154.3050407@redhat.com>
 <4FF088B9.1000308@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF088B9.1000308@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2012 at 10:28:25AM -0700, John Stultz wrote:
> 
> Reworking the patch now.

John,

I know you didn't like my (originally Michael Hack's) idea of keeping
time in TAI, but wouldn't changing to an internal, continuous time
scale (not necessary TAI) solve these sorts of timer issues?

There have been a number of clock/timer/leap bugs over the last
years. Some of these might have been avoided by using a continuous
scale, since no special timer actions would be needed during a leap
second.

The run time cost is low, just one additional test and addition when
reading the time. It might be worth it for the peace of mind when
the next leap second rolls around.

Thanks,
Richard
