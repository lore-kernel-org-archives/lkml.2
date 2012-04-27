Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab2D0WDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:03:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab2D0WDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:03:32 -0400
Date: Fri, 27 Apr 2012 15:03:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sameer Nanda <snanda@chromium.org>
Cc: mingo@redhat.com, peterz@infradead.org, len.brown@intel.com, pavel@ucw.cz,
        rjw@sisk.pl, dzickus@redhat.com, msb@chromium.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        olofj@chromium.org
Subject: Re: [PATCH] watchdog: fix for lockup detector breakage on resume
Message-Id: <20120427150330.783a5b97.akpm@linux-foundation.org>
In-Reply-To: <CANMivWaAN9D=-BjSP=frHijWK+K3abAo9nCuW8o+rPSDdHgm7g@mail.gmail.com>
References: <1335550240-17765-1-git-send-email-snanda@chromium.org>
	<20120427141257.c90f43e0.akpm@linux-foundation.org>
	<CANMivWaAN9D=-BjSP=frHijWK+K3abAo9nCuW8o+rPSDdHgm7g@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2012 14:40:01 -0700
Sameer Nanda <snanda@chromium.org> wrote:

> On Fri, Apr 27, 2012 at 2:12 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> 
> This call actually happens on "exit from suspend" or "entry into
> resume" processing so
> how about something like:
> 
> On exit from suspend we force an offline->online transition on the boot CPU so
> that the PMU state that was lost while in suspended state gets set up properly
> for the boot CPU.  This information is required for restarting the NMI watchdog.

OK, let's use that.

> > Also, this is all dead code if CONFIG_SUSPEND=n, so how about
> >

You had no comments about this?
