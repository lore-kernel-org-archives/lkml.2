Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934770Ab1ESUwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:52:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40940 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934726Ab1ESUwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:52:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [PATCH 2/4] PM / Loss: power loss management
Date: Thu, 19 May 2011 22:52:46 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Davide Ciminaghi <ciminaghi@gnudd.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Raffaele Recalcati <raffaele.recalcati@bticino.it>,
        linux-pm@lists.linux-foundation.org,
        Raffaele Recalcati <lamiaposta71@gmail.com>
References: <Pine.LNX.4.44L0.1105191021220.1900-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1105191021220.1900-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105192252.46836.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 19, 2011, Alan Stern wrote:
> On Thu, 19 May 2011, Davide Ciminaghi wrote:
> 
> > I'm not completely sure about this. What we wanted to do was to avoid powering
> > down the mmc while it is physically writing data into its internal memory.
> > If we force a sync when the power loss warning event warning happens,
> > it is very difficult to be able to guarantee that all buffered data will be 
> > written before power actually dies. So we preferred to follow another strategy:
> > let the mmc finish any running write operation, and then stop its request 
> > queue. If power really goes down, then we hope that the file system journal 
> > will fix things on next boot (yes, some data could get lost, but the fs should
> > still be mountable). On the other hand, if power resumes, nothing bad should 
> > happen for user space processes.
> 
> You could consider a totally different approach.
> 
> Each platform will have a different set of high-power devices it wants
> to turn off when a power-loss warning occurs.  So instead of changing
> the core PM interface, you could add a new "power_loss" notifier list.  
> Only the most critical drivers would need to listen for notifications, 
> and this could be different drivers on different platforms.

Moreover, it would allow not only drivers, but also filesystems (for
one example) to get notifications.

Thanks,
Rafael
