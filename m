Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964894Ab2FHVou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 17:44:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34955 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934508Ab2FHVot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 17:44:49 -0400
Date: Fri, 8 Jun 2012 14:44:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Sameer Nanda <snanda@chromium.org>, mingo@redhat.com, peterz@infradead.org,
        len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl, dzickus@redhat.com,
        msb@chromium.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, olofj@chromium.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] watchdog: fix for lockup detector breakage on resume
Message-Id: <20120608144447.b8e2d146.akpm@linux-foundation.org>
In-Reply-To: <4FA74089.4080204@linux.vnet.ibm.com>
References: <1335550240-17765-1-git-send-email-snanda@chromium.org>
	<1335892956-30606-1-git-send-email-snanda@chromium.org>
	<4FA74089.4080204@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 May 2012 08:54:57 +0530
Anshuman Khandual <khandual@linux.vnet.ibm.com> wrote:

> On Tuesday 01 May 2012 10:52 PM, Sameer Nanda wrote:
> 
> > On the suspend/resume path the boot CPU does not go though an
> > offline->online transition.  This breaks the NMI detector
> > post-resume since it depends on PMU state that is lost when
> > the system gets suspended.
> 
> 
> We should not have allowed the PMU to go with events counting on it across the suspend/resume transition
> and find out that the state has been lost. This patch solves the problem of the NMI detector as we restart the
> counter again when the boot cpu comes back online during resume. But the original cause (PMU going with
> counters into the suspend state) which triggered this problem is still there. May be we should have called
> perf_event_exit() on the boot cpu before going into the suspend state. 
> 

That sounds like a nicer solution.

An implementation would be nice ;) I'll keep the original patch on life
support until we get all this nailed down.

