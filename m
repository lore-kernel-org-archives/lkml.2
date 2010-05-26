Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab0EZRkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 13:40:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48463 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757138Ab0EZRkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 13:40:20 -0400
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
From: James Bottomley <James.Bottomley@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
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
       tytso@mit.edu
In-Reply-To: <AANLkTinv5C-TO48ZMP0ZV-ne7VbCAhXlARhYOJmhYoRa@mail.gmail.com>
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
	 <AANLkTik9LINPmabJfVi0jfVs5sjVS_1l00WpnVTFEuLV@mail.gmail.com>
	 <1274890736.4467.574.camel@mulgrave.site>
	 <AANLkTinv5C-TO48ZMP0ZV-ne7VbCAhXlARhYOJmhYoRa@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 12:40:11 -0500
Message-ID: <1274895611.4467.805.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 20:25 +0300, Pekka Enberg wrote:
> Hi James,
> 
> On Wed, 2010-05-26 at 13:29 +0300, Pekka Enberg wrote:
> >> Yup, I don't quite get Arve's argument either. C code can interact
> >> with Java code (and vice versa) just fine in userspace.
> 
> On Wed, May 26, 2010 at 7:18 PM, James Bottomley
> <James.Bottomley@suse.de> wrote:
> > This is an incorrect statement.  It's possible for java to call C via
> > the JNI, even though there are quite a few gotchas that mean not just
> > *any* C code can do it (been there, tripped over some of them, although
> > they were all ultimately ironed out).  It's very difficult for C to call
> > directly into Java without being specially coded because it involves
> > creating and managing a JVM (so in general, arbitrary C code can't do
> > this).  The usual way we do C -> Java is process to process via some
> > intermediary like RPC or Corba or SOAP (or even JSON) ... which gets
> > very messy for a mobile device.
> 
> Incorrect statement how exactly? A JVM can do mmap(), for example,
> just fine through FileChannel.map() so there's no need for
> heavy-weight RPC.

Incorrect in that an arbitrary C application can't link to a java API.
mmap and some other messaging (like signals) is just another form of
IPC ... the list I gave wasn't exhaustive.

>  Furthermore, the whole discussion is moot anyway as
> Android runs Dalvik which can be hacked to support whatever
> communication mechanism is the best choice here.
> 
> So can we drop the whole "we need to do it in kernel because Java is
> hard" nonsense and concentrate on real issues?

I've lost you.  This argument seems to hinge on whether or not you
believe that suspend in any form is a solution to the rogue app
problem ... whether it's implemented in Java or C is an ancillary issue.

James


