Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab0DWFZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 01:25:38 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34952 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755520Ab0DWFZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 01:25:36 -0400
Date: Fri, 23 Apr 2010 07:24:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with
 ondemand during disk IO
Message-ID: <20100423052439.GB4829@ucw.cz>
References: <20100418115949.7b743898@infradead.org>
 <20100418120346.1b478410@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100418120346.1b478410@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The ondemand cpufreq governor uses CPU busy time (e.g. not-idle time) as
> a measure for scaling the CPU frequency up or down.
> If the CPU is busy, the CPU frequency scales up, if it's idle, the CPU
> frequency scales down. Effectively, it uses the CPU busy time as proxy
> variable for the more nebulous "how critical is performance right now"
> question.
> 
> This algorithm falls flat on its face in the light of workloads where
> you're alternatingly disk and CPU bound, such as the ever popular
> "git grep", but also things like startup of programs and maildir using
> email clients... much to the chagarin of Andrew Morton.
> 
> This patch changes the ondemand algorithm to count iowait time as busy,
> not idle, time. As shown in the breakdown cases above, iowait is performance
> critical often, and by counting iowait, the proxy variable becomes a more
> accurate representation of the "how critical is performance"
> question.

Well, and now, if you do something like cat /dev/<your usb1.1 hdd> >
/dev/null, you'll keep cpu on max frequency. Not a problem for new
core i7, but probably big deal for athlon 64.

Maybe modern cpus can and should simply react faster?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
