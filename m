Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639Ab1GFGhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 02:37:52 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59477 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1GFGhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 02:37:50 -0400
Date: Wed, 6 Jul 2011 00:37:46 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-i2c@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        linux-kernel@vger.kernel.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Bonesio <bones@secretlab.ca>, Stephen Warren <SWarren@nvidia.com>
Subject: Re: [PATCH] i2c: Allow i2c_add_numbered_adapter() to assign a bus id.
Message-ID: <20110706063746.GA26611@ponder.secretlab.ca>
References: <20110627185505.19423.64214.stgit@ponder>
 <BANLkTi=6zxPUwGZ5JHhRGRHHaEgvNgiaHQ@mail.gmail.com>
 <20110705105330.63c113c8@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110705105330.63c113c8@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 10:53:30AM +0200, Jean Delvare wrote:
> Hi Grant,
> 
> Sorry for the late answer.
> 
> On Mon, 27 Jun 2011 13:02:45 -0600, Grant Likely wrote:
> > On Mon, Jun 27, 2011 at 12:55 PM, Grant Likely
> > <grant.likely@secretlab.ca> wrote:
> > > Currently, if an i2c bus driver supports both static and dynamic bus
> > > ids, it needs to choose between calling i2c_add_numbered_adapter() and
> > > i2c_add_adapter().  This patch makes i2c_add_numbered_adapter()
> > > redirect to i2c_add_adapter() if the requested bus id is -1.
> > >
> > > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> > 
> > Oops, forgot to edit the email before sending the patch.
> > 
> > This patch is as-yet untested other than build testing, but I want to
> > get feedback.  With the move to DT on ARM, there are going to be a lot
> > more i2c bus drivers that need to support both static and dynamically
> > allocated busses, and it is very likely that it will be needed in the
> > v3.1 merge window.
> > 
> > Ben/Jean, *IF* this patch tests out okay, and *IF* I get an ack from
> > you, it will probably need to have this commit in my devicetree/next
> > branch.  If so, then I'll either need to commit it myself, or have it
> > put into a separate topic branch that both of us can merge into our
> > trees.  What is your preference.
> > 
> > John: this is the patch that I asked you to write earlier today, but I
> > think one of the TI folks will run into the same issue, so I wanted to
> > get it drafted and onto the list ASAP.
> 
> If this makes your life easier then I have no objection, you can go
> ahead. I don't expect any conflict with my tree as there is no i2c-core
> work going on on my end at the moment. So you can just take it in your
> tree and merge it yourself as you see fit.
> 
> Acked-by: Jean Delvare <khali@linux-fr.org>

Actually, now that I'm looking at things, I don't think there will be
a conflict.  Go ahead and take it via your tree so that I don't make
Linus' life harder than it needs to be.

g.

