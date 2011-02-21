Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab1BUMa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 07:30:56 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:40480 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753567Ab1BUMaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 07:30:55 -0500
Date: Mon, 21 Feb 2011 14:30:49 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Cohen <dacohen@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, linux-omap@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] headers: fix circular dependency between
 linux/sched.h and linux/wait.h
Message-ID: <20110221123049.GC23087@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1298283649-24532-1-git-send-email-dacohen@gmail.com>
 <1298283649-24532-2-git-send-email-dacohen@gmail.com>
 <AANLkTimwvgLvpvndCqcd_okA2Kk4cu7z4bD3QXTdgWJW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimwvgLvpvndCqcd_okA2Kk4cu7z4bD3QXTdgWJW@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 01:05:51PM +0200, Alexey Dobriyan wrote:
> On Mon, Feb 21, 2011 at 12:20 PM, David Cohen <dacohen@gmail.com> wrote:
> > Currently sched.h and wait.h have circular dependency between both.
> > wait.h defines macros wake_up*() which use macros TASK_* defined by
> > sched.h. But as sched.h indirectly includes wait.h, such wait.h header
> > file can't include sched.h too. The side effect is when some file
> > includes wait.h and tries to use its wake_up*() macros, it's necessary
> > to include sched.h also.
> > This patch moves all TASK_* macros from linux/sched.h to a new header
> > file linux/task_sched.h. This way, both sched.h and wait.h can include
> > task_sched.h and fix the circular dependency. No need to include sched.h
> > anymore when wake_up*() macros are used.
> 
> Just include <linux/sched.h> in your driver.
> This include splitting in small pieces is troublesome as well.

so, simply to call wake_up*() we need to know everything there is to
know about the scheduler ? I rather have the split done and kill the
circular dependency. What does Mingo and Peter think about this ?

-- 
balbi
