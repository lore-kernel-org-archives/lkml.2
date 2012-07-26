Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab2GZUJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 16:09:21 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:59058 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab2GZUJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 16:09:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@android.com>
Subject: Re: [PATCH] cpuidle: coupled: fix sleeping while atomic in cpu notifier
Date: Thu, 26 Jul 2012 22:15:06 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
References: <1343251216-24106-1-git-send-email-ccross@android.com> <201207262155.31280.rjw@sisk.pl> <CAMbhsRRsxC0hCKx-Y_pY8z9F9Sbs52fWhCerGvKbt2fH6AWF5Q@mail.gmail.com>
In-Reply-To: <CAMbhsRRsxC0hCKx-Y_pY8z9F9Sbs52fWhCerGvKbt2fH6AWF5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207262215.06372.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 26, 2012, Colin Cross wrote:
> On Thu, Jul 26, 2012 at 12:55 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday, July 25, 2012, Colin Cross wrote:
> >> The cpu hotplug notifier gets called in both atomic and non-atomic
> >> contexts, it is not always safe to lock a mutex.  Filter out all events
> >> except the six necessary ones, which are all sleepable, before taking
> >> the mutex.
> >
> > I wonder what mutual exclusion mechanis we rely on when the mutex is not taken?
> 
> We don't need any mutual exclusion because the notifier returns immediately.

Don't we need to disable preemption even?
