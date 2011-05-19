Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab1ESOZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 10:25:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54082 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932671Ab1ESOZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 10:25:13 -0400
Date: Thu, 19 May 2011 10:25:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Davide Ciminaghi <ciminaghi@gnudd.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
        Raffaele Recalcati <raffaele.recalcati@bticino.it>,
        <linux-pm@lists.linux-foundation.org>,
        Raffaele Recalcati <lamiaposta71@gmail.com>
Subject: Re: [linux-pm] [PATCH 2/4] PM / Loss: power loss management
In-Reply-To: <20110519092625.GB1446@mail.gnudd.com>
Message-ID: <Pine.LNX.4.44L0.1105191021220.1900-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011, Davide Ciminaghi wrote:

> I'm not completely sure about this. What we wanted to do was to avoid powering
> down the mmc while it is physically writing data into its internal memory.
> If we force a sync when the power loss warning event warning happens,
> it is very difficult to be able to guarantee that all buffered data will be 
> written before power actually dies. So we preferred to follow another strategy:
> let the mmc finish any running write operation, and then stop its request 
> queue. If power really goes down, then we hope that the file system journal 
> will fix things on next boot (yes, some data could get lost, but the fs should
> still be mountable). On the other hand, if power resumes, nothing bad should 
> happen for user space processes.

You could consider a totally different approach.

Each platform will have a different set of high-power devices it wants
to turn off when a power-loss warning occurs.  So instead of changing
the core PM interface, you could add a new "power_loss" notifier list.  
Only the most critical drivers would need to listen for notifications, 
and this could be different drivers on different platforms.

Alan Stern

