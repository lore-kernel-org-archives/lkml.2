Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475Ab0E0JNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 05:13:16 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:4464 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757184Ab0E0JNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 05:13:09 -0400
X-Greylist: delayed 3076 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 May 2010 05:13:08 EDT
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o4R8D7AS018652
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Florian Mickler <florian@mickler.org>
Cc: Pavel Machek <pavel@ucw.cz>, James Bottomley <James.Bottomley@suse.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Arve Hj?nnev?g <arve@android.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
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
In-Reply-To: <20100526211542.1bfa2564@schatten.dmk.lab>
References: <AANLkTil9ZtMFxTfE6ITiFNOl4S1k3Lvdp5BPgGX7LJhw@mail.gmail.com>
	 <1274868384.5882.5169.camel@twins>
	 <AANLkTimHGpRAZklIwXu6wEbA3coKXJvCVLxj2twerkCw@mail.gmail.com>
	 <1274869262.5882.5222.camel@twins>
	 <AANLkTik9LINPmabJfVi0jfVs5sjVS_1l00WpnVTFEuLV@mail.gmail.com>
	 <1274890736.4467.574.camel@mulgrave.site>
	 <1274891308.1674.1766.camel@laptop>
	 <1274892847.4467.674.camel@mulgrave.site>
	 <1274893228.1674.1772.camel@laptop>
	 <1274894042.4467.727.camel@mulgrave.site>
	 <20100526172824.GA9069@elf.ucw.cz>
	 <20100526211542.1bfa2564@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 10:13:07 +0200
Message-ID: <1274947987.14002.24.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-DCC-wuwien-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2010-05-26 at 21:15 +0200, Florian Mickler wrote:
> On Wed, 26 May 2010 19:28:24 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > Besides that it is not linux system at all?
> 
> I believe the kernel to be a layer between userspace and hardware. What
> business is it to the kernel if it runs whatever android
> uses as init process or /bin/bash, sys-v-init or systemd?

The kernel has no business and doesn't care. But precisely that is the
reason to clearly separate policy from means. And that separation is not
done in a good way by a loosely-defined API but by a (well-defined)
kernel-API which allows user-space so implement the policy (whatever it
might feel) by using the means (wiht appopriate parameters).
So the (kernel-)API should not use policy-defined (read: user-space)
semantics/values - plain simply because they will change (in no time).
But the kernel must use policy-independent semantics/values - if only
the suspend/wakeup-latency or whatever technically makes sense.
Perhaps some "will/want to be waken up every 0.1 second" makes sense for
periodic jobs.

> There is this thing called choice. 
>
> > Yes, with custom userspace it works extremely nicely.
> > 
> > Had anyone even tried running oportunistic suspend on normal desktop?
>
> I don't think this is a valid concern. Just because current linux/gnu

A lot of stuff is not (or no longer) implemented because it's - plain
simply - a bad idea in the first place.
Other than that: Linux/GNU-systems come from the server and desktop
world where power is not an important part. And laptop producers
obviously didn't care enough ...
And you do realize that in the non-embedded (and non-Apple) world the
user-space is not controlled by one entity in any way.
So forcing "good apps" vs "bad apps" doesn't workout - except you have
direct feedback like "powertop" which makes it easy for everyone
(especially the users) to rate the apps.
So the kernel actually must have means to do that. If user-space defines
the semantics of the API, the kernel can't do that because user-space is
always right.

> systems don't implement the userspace part of this interface doesn't
> mean it is useless or broken. 

Just because Android designed and/or implements it doesn't mean it's not
broken (in the medium to long run).
So what?

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

