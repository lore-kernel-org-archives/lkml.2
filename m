Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab0FGUBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 16:01:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753785Ab0FGUBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 16:01:08 -0400
Date: Mon, 7 Jun 2010 13:00:15 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Flavio Leitner <fleitner@redhat.com>, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>, Cong Wang <amwang@redhat.com>,
       Jay Vosburgh <fubar@us.ibm.com>, Flavio Leitner <fbl@sysclose.org>,
       Andy Gospodarek <gospo@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
       Jeff Moyer <jmoyer@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       bridge@lists.linux-foundation.org, bonding-devel@lists.sourceforge.net
Subject: Re: [PATCH] netconsole: queue console messages to send later
Message-ID: <20100607130015.15555744@nehalam>
In-Reply-To: <1275940248.26597.70.camel@calx>
References: <24059.1275417767@death.nxdomain.ibm.com>
	<1275938692-26997-1-git-send-email-fleitner@redhat.com>
	<1275940248.26597.70.camel@calx>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Jun 2010 14:50:48 -0500
Matt Mackall <mpm@selenic.com> wrote:

> On Mon, 2010-06-07 at 16:24 -0300, Flavio Leitner wrote:
> > There are some networking drivers that hold a lock in the
> > transmit path. Therefore, if a console message is printed
> > after that, netconsole will push it through the transmit path,
> > resulting in a deadlock.
> 
> This is an ongoing pain we've known about since before introducing the
> netpoll code to the tree.
> 
> My take has always been that any form of queueing is contrary to the
> goal of netpoll: timely delivery of messages even during machine-killing
> situations like oopses. There may never be a second chance to deliver
> the message as the machine may be locked solid. And there may be no
> other way to get the message out of the box in such situations. Adding
> queueing is a throwing-the-baby-out-with-the-bathwater fix.
> 
> I think Dave agrees with me here, and I believe he's said in the past
> that drivers trying to print messages in such contexts should be
> considered buggy.
> 

Because it to hard to fix all possible device configurations.
There should be any way to detect recursion and just drop the message to
avoid deadlock.

-- 
