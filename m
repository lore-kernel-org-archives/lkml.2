Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab2GSOG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 10:06:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab2GSOGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 10:06:22 -0400
Date: Thu, 19 Jul 2012 10:06:10 -0400
From: Don Zickus <dzickus@redhat.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, lwoodman@redhat.com,
        jbaron@redhat.com
Subject: Re: [PATCH] tty, add kref to sysrq handlers
Message-ID: <20120719140609.GA15158@redhat.com>
References: <1339514522-1742-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339514522-1742-1-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 11:22:02AM -0400, Prarit Bhargava wrote:
> [This seems to have been missed ... sending again]
> 
> On a large system with a large number of tasks, the output of
> 
> echo t > /proc/sysrq-trigger
> 
> can take a long period of time.  If this period is greater than the period
> of the current clocksource, the clocksource watchdog will mark the
> clocksource as unstable and fail the clocksource over.

A lot of our customers are running into this issue (especially the big
boxes).  This is patch solves their problem nicely.

The approach is a little heavier than the current approach, but it allows
a useful feature like sysrq-t to work reliably.

Acked-by: Don Zickus <dzickus@redhat.com>
