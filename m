Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab0EZQ2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:28:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:41490 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab0EZQ2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:28:37 -0400
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
From: Peter Zijlstra <peterz@infradead.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
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
In-Reply-To: <1274890736.4467.574.camel@mulgrave.site>
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
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 18:28:28 +0200
Message-ID: <1274891308.1674.1766.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 11:18 -0500, James Bottomley wrote:
> > Or make the suspend manager a C proglet and provide a JNI interface,
> > or whatever.
> 
> It's a fairly large piece of code to try to rewrite in C, so I don't
> think that's feasible on a reasonable timescale.  Android does have the
> concept of special sockets that can be used to communicate from less to
> more privileged processes (it has a very segmented runtime model), so
> these might be usable ... they have a drawback that they're essentially
> named pipes, so no multiplexing, but one per suspend influencing C
> process shouldn't be a huge burden. 

It wouldn't need to convert the whole Frameworks layer into C, just
enough to manage the suspend state.

Anyway, I think there's been enough arguments against even the concept
of opportunistic/auto-suspend, and I for one will object with a NAK if
Rafael send this to Linus.

The whole idea of segregating userspace like that, and not letting
runnable thing run is very ill considered indeed.

