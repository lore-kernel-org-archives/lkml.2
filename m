Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031078Ab2COW1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 18:27:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47746 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759898Ab2COW1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 18:27:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] firmware_class: Move request_firmware_nowait() to workqueues
Date: Thu, 15 Mar 2012 23:31:14 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>
References: <1331841015-26684-1-git-send-email-sboyd@codeaurora.org> <201203152107.57501.chunkeey@googlemail.com> <4F624D32.9030801@codeaurora.org>
In-Reply-To: <4F624D32.9030801@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203152331.14314.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 15, 2012, Stephen Boyd wrote:
> On 03/15/12 13:07, Christian Lamparter wrote:
> > On Thursday, March 15, 2012 08:50:15 PM Stephen Boyd wrote:
> >> Oddly enough a work_struct was already part of the firmware_work
> >> structure but nobody was using it. Instead of creating a new
> >> kthread for each request_firmware_nowait() just schedule the work
> >> on the system workqueue. This should avoid some overhead in
> >> forking new threads when they're not strictly necessary if
> >> workqueues are available.
> >>
> >> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> Cc: Kay Sievers <kay.sievers@vrfy.org>
> >> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> >> ---
> >>
> >> I saw this while looking at this problem we're having.
> > Correct me if I'm wrong, but wouldn't that stall all other
> > global workqueue tasks for up to 60 seconds [in worst case]?
> >
> > But I think we can get rid of the firmware_work work struct...
> >
> 
> My understanding is that with concurrency managed workqueues when the
> work item blocks another will be scheduled to run almost immediately. So
> before that change by Tejun workqueues would have been a bad idea
> because it could have blocked up to 60 second but now it should be fine
> because that work item will just be put to sleep and another request
> will run.

Please read the description of system_wq in workqueue.h.

You should have used either system_long_wq or system_nrt_wq (depending on
what you really need).

Thanks,
Rafael
