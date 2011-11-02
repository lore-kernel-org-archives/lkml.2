Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab1KBFrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 01:47:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58884 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab1KBFrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 01:47:06 -0400
Date: Tue, 1 Nov 2011 22:46:58 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrew Watts <akwatts@ymail.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        tj@kernel.org
Subject: Re: [REGRESSION]: hibernate/sleep regression w/ bisection
Message-ID: <20111102054658.GA29035@core.coreip.homeip.net>
References: <20111101124759.GA1326@zeus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101124759.GA1326@zeus>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, Nov 01, 2011 at 07:48:19AM -0500, Andrew Watts wrote:
> Hi.
> 
> Hibernate/sleep (echo disk/mem > /sys/power/state) has presented problems
> for me starting with 2.6.39. Kernel 2.6.37.6 was the last completely bug-free
> version I used (I skipped the 2.6.38 branch entirely).
> 
> The symptoms are that upon resume (from sleep/hibernate) there is no video
> nor any keyboard input with the exception of sysrq.

If SysRq is working that means that i8042, atkbd and input core are
working properly.

> 
> It has been a frustrating bug to hunt down because it is not easily
> reproduced; sometimes the bug doesn't pop up until after a long sequence of
> hibernate/sleep cycles.
> 
> I successfully bisected the problem to: 8ee294cd9def000.
> 
> =======
> Commit: 8ee294cd9def0004887da7f44b80563493b0a097
> Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Date:   Mon Nov 15 01:39:57 2010 -0800
> Input: serio - convert to common workqueue instead of a thread
> =======
> 
> Backing out 8ee294cd9def000 (which requires reversing part of
> 1d64b655dc083df also) fixes this particular problem on 2.6.39.4,
> 3.0.8, and 3.1.

I am not sure how this commit could cause your "no video" issue...
Are you hibernating from text console or X? Can you try plugging in USB
keyboard and see if you are getting input? What about ssh into the box?

Thanks.

-- 
Dmitry
