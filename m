Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab0CZVYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:24:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441Ab0CZVYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:24:35 -0400
Date: Fri, 26 Mar 2010 14:24:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yury Polyanskiy <ypolyans@princeton.edu>
Cc: Joel Becker <joel.becker@oracle.com>, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>, Jan Glauber <jan.glauber@de.ibm.com>
Subject: Re: [PATCH] hangcheck-timer is broken on x86
Message-Id: <20100326142423.1334d407.akpm@linux-foundation.org>
In-Reply-To: <20100323233611.6dcbe4f4@penta.localdomain>
References: <20100323233611.6dcbe4f4@penta.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Mar 2010 23:36:11 -0400
Yury Polyanskiy <ypolyans@princeton.edu> wrote:

> The drivers/char/hangcheck-timer.c is doubly broken. First, the
> following line overflows unsigned long:
> # define TIMER_FREQ (HZ*loops_per_jiffy)
> 
> Second, and more importantly, loops_per_jiffy has little to do with the conversion from the
> the time scale of get_cycles() (aka rdtsc) to the time scale of jiffies.

It's a bit odd to have a driver be this broken on x86_32 for five years
without anyone noticing.  What are the user-visible effects of these
shortcomings?

Also, please do send us a Signed-off-by: for this patch, as explained
in Documentation/SubmittingPatches, thanks.

