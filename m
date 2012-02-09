Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab2BIA4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 19:56:35 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58663 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab2BIA4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 19:56:34 -0500
Date: Wed, 8 Feb 2012 16:56:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 3/6] staging: android/lowmemorykiller: Don't grab
 tasklist_lock
Message-ID: <20120209005610.GA16599@kroah.com>
References: <20120203163056.GA4190@redhat.com>
 <20120206162941.GC5117@oksana.dev.rtsoft.ru>
 <20120206163649.GB10104@kroah.com>
 <20120206164215.GA7741@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206164215.GA7741@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 08:42:15PM +0400, Anton Vorontsov wrote:
> On Mon, Feb 06, 2012 at 08:36:49AM -0800, Greg KH wrote:
> > On Mon, Feb 06, 2012 at 08:29:41PM +0400, Anton Vorontsov wrote:
> > > Grabbing tasklist_lock has its disadvantages, i.e. it blocks
> > > process creation and destruction. If there are lots of processes,
> > > blocking doesn't sound as a great idea.
> > > 
> > > For LMK, it is sufficient to surround tasks list traverse with
> > > rcu_read_{,un}lock().
> > > 
> > > >From now on using force_sig() is not safe, as it can race with an
> > > already exiting task, so we use send_sig() now. As a downside, it
> > > won't kill PID namespace init processes, but that's not what we
> > > want anyway.
> > > 
> > > Suggested-by: Oleg Nesterov <oleg@redhat.com>
> > > Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> > 
> > Are these last 4 patches independant of the first 2 and can be taken
> > through the staging tree now?
> 
> Yep, without the first two there is just a bit of sparse warnings.
> Not a big deal.

Ok, I'll take the last 4, the first 2 needs to go through some other
tree (-mm?)

thanks,

greg k-h
