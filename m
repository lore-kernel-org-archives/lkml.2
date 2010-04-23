Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab0DWQps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:45:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49955 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758219Ab0DWQpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:45:42 -0400
Date: Fri, 23 Apr 2010 12:45:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
cc: Len Brown <len.brown@intel.com>, <linux-doc@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Magnus Damm <damm@igel.co.jp>, <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/9] PM: Add suspend block api.
In-Reply-To: <Pine.LNX.4.44L0.1004231204450.1777-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.44L0.1004231244090.1777-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010, Alan Stern wrote:

> On Thu, 22 Apr 2010, [UTF-8] Arve Hjønnevåg wrote:

> > +struct suspend_blocker {
> > +#ifdef CONFIG_SUSPEND_BLOCKERS
> > +	atomic_t            flags;
> > +	const char         *name;
> > +#endif
> 
> Why is flags an atomic_t?  Are you worried that drivers might try to 
> activate a suspend_blocker at the same time that it is being destroyed?
> If this happens, does the code do the right thing?  I don't think it 
> does -- if a race occurs, suspend_block() will leave flags set to the 
> wrong value.  The same goes for suspend_unblock().
> 
> Since these routines don't nest, there is also the possibility of a
> race between suspend_block() and suspend_unblock().  If the race goes
> one way the blocker is active; the other way it isn't.  Given that such
> problems already exist, why worry about what happens when the suspend
> blocker is destroyed?

Having now read the later patches, I see that you switch over to using 
a spinlock instead of an atomic_t.  My suggestion is to use a spinlock 
right from the start.  It will be less confusing.

Alan Stern

