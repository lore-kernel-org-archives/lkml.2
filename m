Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab0JROdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:33:50 -0400
Received: from canuck.infradead.org ([134.117.69.58]:39795 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab0JROds convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:33:48 -0400
Subject: Re: [PATCH 0/3] Add OMAP hardware spinlock misc driver
From: Peter Zijlstra <peterz@infradead.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, akpm@linux-foundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <AANLkTimYK_JVafj5XdN+d9O8h_qon17Jkw7LRpJVZvuO@mail.gmail.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
	 <1287406015.29097.1579.camel@twins>
	 <20101018133502.GA12449@n2100.arm.linux.org.uk>
	 <1287409417.29097.1598.camel@twins>
	 <AANLkTimYK_JVafj5XdN+d9O8h_qon17Jkw7LRpJVZvuO@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Oct 2010 16:33:03 +0200
Message-ID: <1287412383.29097.1603.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 16:28 +0200, Ohad Ben-Cohen wrote:
> On Mon, Oct 18, 2010 at 3:43 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > Right, so the problem is that there simply is no way to do atomic memory
> > access from these auxiliary processing units wrt the main CPU?
> 
> Yes. There are a few relevant system-wide limitations, one of them is
> that simply the system interconnect does not support those fancy
> atomic operations.

Does it support full memory coherency though? Otherwise I can see memory
based message passing becoming rather interesting.

Without coherency everybody needs to be damn sure to flush the relevant
bits before unlocking and such.


