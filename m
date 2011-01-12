Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab1ALJ0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 04:26:19 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:37431 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab1ALJ0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 04:26:14 -0500
Subject: Re: 2.6.37-git5 -- INFO: possible irq lock inversion dependency
 detected
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "John W. Linville" <linville@tuxdriver.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <AANLkTin4n+OQMSTdbsMBrKxhe494Uq2Db-0Fg65ao2iL@mail.gmail.com>
References: <AANLkTin4n+OQMSTdbsMBrKxhe494Uq2Db-0Fg65ao2iL@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 10:26:53 +0100
Message-ID: <1294824413.3639.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-11 at 15:10 -0500, Miles Lane wrote:
> [ INFO: possible irq lock inversion dependency detected ]
> 2.6.37-git5 #1
> ---------------------------------------------------------
> dbus-daemon/1512 just changed the state of lock:
>  (&(&list->lock)->rlock#7){+.-...}, at: [<ffffffffa01d4ecc>]
> ieee80211_rx_handlers+0x36/0x1ae3 [mac80211]
> but this lock was taken by another, HARDIRQ-safe lock in the past:
>  (&(&priv->lock)->rlock){-.-...}
> 
> and interrupts could create inverse lock ordering between them.

Thanks Miles. I'm not sure I fully understand this trace, but I think
you can probably easily reproduce it. Would you be willing to test with
the patch on this email? I think it's related:

http://thread.gmane.org/gmane.linux.kernel.wireless.general/62842/focus=62848

johannes

