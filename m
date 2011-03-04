Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551Ab1CDMUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 07:20:37 -0500
Received: from shutemov.name ([188.40.19.243]:42934 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759400Ab1CDMUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 07:20:36 -0500
Date: Fri, 4 Mar 2011 14:20:35 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH, v8 1/3] hrtimer: introduce effective timer slack
Message-ID: <20110304122035.GB14933@shutemov.name>
References: <1299161947-9903-1-git-send-email-kirill@shutemov.name>
 <1299161947-9903-2-git-send-email-kirill@shutemov.name>
 <201103031732.28964.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103031732.28964.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 05:32:28PM +0100, Arnd Bergmann wrote:
> On Thursday 03 March 2011, Kirill A. Shutsemov wrote:
> > task_get_effective_timer_slack() returns timer slack value to be used
> > to configure per-task timers. It can be equal or higher than task's
> > timer slack value.
> > 
> > For now task_get_effective_timer_slack() returns timer_slack_ns of the
> > task. Timer slack cgroup controller will implement a bit more
> > sophisticated logic.
> 
> Some time ago, there was a discussion about a method for automatically
> determining timer slack values, and I think nobody ever implemented it.
> 
> The idea was to penalize tasks that have timers expiring a lot, typically
> a sign of programs that were not written with power consumption in mind.
> 
> I think that could be nicely combined with your patch. Instead of setting
> the effective timer slack for the entire control group, you  could
> set a target value that is applied only to tasks that have their timers
> expire frequently. When a timer expires for a task, you increase the
> effective slack up to the maximum, and when you set up a timer, you
> decrease it again. The amount by which the effective slack gets changed
> can depend on how long ago the last timer expired.
> 
> Does this make sense to you?

Hm.. I think we can add this kind of functionality to timer slack cgroup
as a policy/stratagy later. I want to integrate basic functionality to
kernel first.

-- 
 Kirill A. Shutemov
