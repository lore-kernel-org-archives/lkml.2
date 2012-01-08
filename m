Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab2AHMpQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 07:45:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50423 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2AHMpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 07:45:14 -0500
Subject: Re: [PATCH] ALSA: usb-audio: fix possible hang and overflow in parse_uac2_sample_rate_range()
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <s5hehvamuh4.wl%tiwai@suse.de>
Date: Sun, 8 Jan 2012 07:45:09 -0500
Cc: Jaroslav Kysela <perex@perex.cz>, Clemens Ladisch <clemens@ladisch.de>,
        Daniel Mack <zonque@gmail.com>, Wolfgang Breyha <wbreyha@gmx.net>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <780588F2-6183-44B3-8EB8-CB82FB3DD8A7@gmail.com>
References: <1325698749-5353-1-git-send-email-xi.wang@gmail.com> <s5hehvamuh4.wl%tiwai@suse.de>
To: Takashi Iwai <tiwai@suse.de>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2012, at 4:09 AM, Takashi Iwai wrote:
> As of now, I have little time to evaluate, so I might have missed
> something, but I wonder whether 
> 
> 		/* avoid overflow */
> 		if (nr_rates == KMALLOC_MAX_SIZE / sizeof(int))
> 			break;
> 
> is the best way to check.  This looks ugly to me.
> If we need to limit the number of rates, better to define some proper
> numbers as the upper limit.  And then, it should warn, not only
> breaking loop.

Thanks for looking into this.  Yeah, I agree using something like
MAX_NR_RATES is better.  Is 65535 okay or do we need a larger limit?

- xi
