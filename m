Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab0E0HfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 03:35:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab0E0HfU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 03:35:20 -0400
Date: Thu, 27 May 2010 17:34:57 +1000
From: Neil Brown <neilb@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
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
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       tytso@mit.edu, James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
Message-ID: <20100527173457.167bdd87@notabene.brown>
In-Reply-To: <1274869262.5882.5222.camel@twins>
References: <Pine.LNX.4.44L0.1005251647530.1634-100000@iolanthe.rowland.org>
	<201005252344.37639.rjw@sisk.pl>
	<AANLkTimL5rU5lALezEZVCwdcZL85tVahhsTibdpq9s-Y@mail.gmail.com>
	<1274863342.5882.4850.camel@twins>
	<20100526112303.3fef15a4@schatten.dmk.lab>
	<1274866402.5882.5051.camel@twins>
	<AANLkTil9ZtMFxTfE6ITiFNOl4S1k3Lvdp5BPgGX7LJhw@mail.gmail.com>
	<1274868384.5882.5169.camel@twins>
	<AANLkTimHGpRAZklIwXu6wEbA3coKXJvCVLxj2twerkCw@mail.gmail.com>
	<1274869262.5882.5222.camel@twins>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 12:21:02 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2010-05-26 at 03:17 -0700, Arve Hjønnevåg wrote:
> > > With a single suspend manager process that manages the suspend state you
> > > can achieve the same goal.
> > >
> > 
> > Yes we don't need the /dev interface, but it is useful. Without it any
> > program that needs to block suspend has to make a blocking ipc call
> > into the suspend manager process. Android already does this for java
> > code, but system processes written in C block suspend directly with
> > the kernel since they cannot use the java APIs. 
> 
> So provide a C interface to it as well?
> 
> Surely you can have the java thing have a unix socket or something a C
> app can talk to. That shouldn't be hard at all.
> 
> Or make the suspend manager a C proglet and provide a JNI interface, or
> whatever.

I fail to understand the modern fascination with complex IPC mechanisms.

If you have a userspace process that initiates suspends, and you want other
user-space processes to be able to block that suspend, then I would suggest
the use of a lock-file.  /var/run/suspend/blocked maybe.

To block suspend, you open the file and get a read lock.
To initiate a suspend you take a write-lock (blocking if necessary), then
ask the kernel to suspend.
To restrict access to particular users you use permissions - either group
based or ACLs (or both).
This is all easy to do from C or python or perl or presumably even java..
(I use this mechanism on my Freerunner and even have shell scripts that
happily prevent suspend).

NeilBrown
