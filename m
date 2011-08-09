Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab1HIMBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 08:01:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab1HIMBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 08:01:45 -0400
Date: Tue, 9 Aug 2011 15:02:07 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Chris Wright <chrisw@redhat.com>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio/gen-pci: don't enable interrupts in ISR
Message-ID: <20110809120206.GB524@redhat.com>
References: <20110804204606.GA19724@linutronix.de>
 <20110804210413.GA29222@redhat.com>
 <20110805191842.GA4224@linutronix.de>
 <20110808064050.GC5182@redhat.com>
 <4E411D72.7000604@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E411D72.7000604@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 01:43:46PM +0200, Sebastian Andrzej Siewior wrote:
> Michael S. Tsirkin wrote:
> >>It seems to me that you could drop this "user block" thing
> >>since you never change anything outside of this command register and it
> >>does not stop the race.
> >
> >I don't think so: if we did, we would lose userspace modifications to
> >other bits such as io enable, and there's no way to guess what their
> >values should be.
> 
> How so?
> 
> Sebastian

Let's assume we start with e.g. io enable bit cleared.


    user                                kernel
 read config                               |
 set io enable                             |
     |                                  interrupt                                                
     |                              read + set interrupt mask
 write config back                         |
					write



We end up with io enable bit cleared. Locking around rmw
that we have fixes this race.

-- 
MST
