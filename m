Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361Ab2JHElj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 00:41:39 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:48897 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab2JHElh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 00:41:37 -0400
Date: Sun, 7 Oct 2012 21:41:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org
Subject: Re: Deadlock on poweroff
Message-ID: <20121008044128.GA31861@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121007024711.GA21403@shutemov.name>
 <20121007160311.GE2485@linux.vnet.ibm.com>
 <20121007165012.GA23535@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121007165012.GA23535@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100804-7408-0000-0000-0000091B861A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2012 at 07:50:12PM +0300, Kirill A. Shutemov wrote:
> On Sun, Oct 07, 2012 at 09:03:11AM -0700, Paul E. McKenney wrote:
> > On Sun, Oct 07, 2012 at 05:47:11AM +0300, Kirill A. Shutemov wrote:
> > > Hi Paul and all,
> > > 
> > > With commit 755609a9087fa983f567dc5452b2fa7b089b591f I've got deadlock on
> > > poweroff.
> > > 
> > > It guess it happens because of race for cpu_hotplug.lock:
> > > 
> > > 	CPU A					CPU B
> > > disable_nonboot_cpus()
> > > _cpu_down()
> > > cpu_hotplug_begin()
> > >  mutex_lock(&cpu_hotplug.lock);
> > > __cpu_notify()
> > > padata_cpu_callback()
> > > __padata_remove_cpu()
> > > padata_replace()
> > > synchronize_rcu()
> > > 					rcu_gp_kthread()
> > > 					get_online_cpus();
> > > 					mutex_lock(&cpu_hotplug.lock);
> > > 
> > > Have you seen the issue before?
> > 
> > This is a new one for me.  Does the following (very lightly tested)
> > patch help?
> 
> Works for me. Thanks.

May I add your Tested-by?

							Thanx, Paul

