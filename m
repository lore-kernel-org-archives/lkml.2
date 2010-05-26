Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab0EZMuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:50:22 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41516 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab0EZMuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:50:18 -0400
Date: Wed, 26 May 2010 13:49:29 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org,
       Greg KH <gregkh@suse.de>, tytso@mit.edu,
       James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
Message-ID: <20100526124929.GA32580@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1005251647530.1634-100000@iolanthe.rowland.org> <201005252344.37639.rjw@sisk.pl> <AANLkTimL5rU5lALezEZVCwdcZL85tVahhsTibdpq9s-Y@mail.gmail.com> <1274863342.5882.4850.camel@twins> <1274863987.5882.4892.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274863987.5882.4892.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While this approach could be made to work, it's ugly in other ways. 
After wakeup, userspace has to pause for a while before it can trigger 
another sleep in order to give all the apps an opportunity to check for 
wakeup events and block suspend if they wish to. That's additional 
runtime that doesn't exist in the kernel-mediated case.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
