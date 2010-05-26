Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab0EZQTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:19:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:49059 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902Ab0EZQTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:19:08 -0400
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
In-Reply-To: <AANLkTik9LINPmabJfVi0jfVs5sjVS_1l00WpnVTFEuLV@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 11:18:56 -0500
Message-ID: <1274890736.4467.574.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 13:29 +0300, Pekka Enberg wrote:
> Yup, I don't quite get Arve's argument either. C code can interact
> with Java code (and vice versa) just fine in userspace.

This is an incorrect statement.  It's possible for java to call C via
the JNI, even though there are quite a few gotchas that mean not just
*any* C code can do it (been there, tripped over some of them, although
they were all ultimately ironed out).  It's very difficult for C to call
directly into Java without being specially coded because it involves
creating and managing a JVM (so in general, arbitrary C code can't do
this).  The usual way we do C -> Java is process to process via some
intermediary like RPC or Corba or SOAP (or even JSON) ... which gets
very messy for a mobile device.

On Wed, 2010-05-26 at 12:21 +0200, Peter Zijlstra wrote:
> So provide a C interface to it as well?

The way Android is currently coded, all user space suspend blocks are
handled in Java code at what's called the Frameworks layer (Frameworks
is the Java API for apps) this is also how the suspend permissions are
managed and presented to the user.  The few C applications which block
suspend just manipulate the device directly.

> Surely you can have the java thing have a unix socket or something a C
> app can talk to. That shouldn't be hard at all.
> 
> Or make the suspend manager a C proglet and provide a JNI interface,
> or whatever.

It's a fairly large piece of code to try to rewrite in C, so I don't
think that's feasible on a reasonable timescale.  Android does have the
concept of special sockets that can be used to communicate from less to
more privileged processes (it has a very segmented runtime model), so
these might be usable ... they have a drawback that they're essentially
named pipes, so no multiplexing, but one per suspend influencing C
process shouldn't be a huge burden.

James


