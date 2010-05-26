Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab0EZUGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:06:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab0EZUGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:06:23 -0400
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
From: James Bottomley <James.Bottomley@suse.de>
To: Valdis.Kletnieks@vt.edu
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Pavel Machek <pavel@ucw.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Arve Hj?nnev?g <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       tytso@mit.edu
In-Reply-To: <15650.1274899857@localhost>
References: <1274863342.5882.4850.camel@twins>
	 <20100526112303.3fef15a4@schatten.dmk.lab>
	 <1274866402.5882.5051.camel@twins>
	 <AANLkTil9ZtMFxTfE6ITiFNOl4S1k3Lvdp5BPgGX7LJhw@mail.gmail.com>
	 <1274868384.5882.5169.camel@twins>
	 <AANLkTimHGpRAZklIwXu6wEbA3coKXJvCVLxj2twerkCw@mail.gmail.com>
	 <1274869262.5882.5222.camel@twins>
	 <AANLkTik9LINPmabJfVi0jfVs5sjVS_1l00WpnVTFEuLV@mail.gmail.com>
	 <1274890736.4467.574.camel@mulgrave.site>
	 <1274891308.1674.1766.camel@laptop> <20100526165919.GB2089@elf.ucw.cz>
	 <1274893309.1674.1773.camel@laptop>
	 <1274894685.4467.758.camel@mulgrave.site>
	 <alpine.LFD.2.00.1005261948290.2995@localhost.localdomain>
	 <1274898180.4467.925.camel@mulgrave.site>  <15650.1274899857@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 15:06:11 -0500
Message-ID: <1274904371.4467.1145.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 14:50 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 26 May 2010 13:23:00 CDT, James Bottomley said:
> > On Wed, 2010-05-26 at 19:51 +0200, Thomas Gleixner wrote:
> > > Darn, _we_ have to deal with that forever as it sets a crappy user
> > > space ABI in stone.
> > 
> > I really don't see how it is ... the ABI comes with a switch that allows
> > it to be disabled, so only platforms wishing to use it have to support
> > it.  Even on those platforms that do support it, we can translate most
> > of it into pm QoS stuff and if one day someone solves the rogue app
> > problem, we can migrate over.
> 
> And yet, the OSS drivers are *still* in-tree, even though similar arguments
> apply to an OSS->ALSA migration.  And there's a bunch of other stuff in
> Documentation/feature-removal-schedule.txt in a similar situation.

On the other hand APM, which is what all laptops used to use to suspend
is gone from the x86 kernel today ... replaced by ACPI or other platform
mechanisms, so it is at least possible.

James


