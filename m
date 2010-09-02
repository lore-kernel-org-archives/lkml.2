Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab0IBUp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:45:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39162 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750778Ab0IBUp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:45:26 -0400
Date: Thu, 2 Sep 2010 16:45:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Colin Cross <ccross@android.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
        <linux-pm@lists.linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] PM: Prevent waiting forever on asynchronous resume after
 abort
In-Reply-To: <AANLkTi=s3_kFvRY9Afzku82gUgW7YKYXDBZvTkxQsMP8@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1009021642320.1311-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010, Colin Cross wrote:

> >> I think it would be better to change device_pm_init() and add a
> >> complete_all().
> >
> > I agree.
> That would work, and was my first solution, but it increases the
> reliance on the completion variable being left completed between state
> transitions, which is undocumented and unnecessary.  It seems more
> straightforward to me to only wait on the parent if the parent is
> suspended.

How about calling complete_all() from within dpm_prepare() as well?  
Then it will get initialized properly at the beginning of every sleep 
transition.

Alan Stern

