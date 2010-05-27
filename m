Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab0E0JHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 05:07:25 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:59739 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab0E0JHX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 05:07:23 -0400
MIME-Version: 1.0
In-Reply-To: <1274948234.14002.27.camel@thorin>
References: <1274863342.5882.4850.camel@twins>
	<20100526112303.3fef15a4@schatten.dmk.lab>
	<1274866402.5882.5051.camel@twins>
	<AANLkTil9ZtMFxTfE6ITiFNOl4S1k3Lvdp5BPgGX7LJhw@mail.gmail.com>
	<1274868384.5882.5169.camel@twins>
	<AANLkTimHGpRAZklIwXu6wEbA3coKXJvCVLxj2twerkCw@mail.gmail.com>
	<1274869262.5882.5222.camel@twins>
	<AANLkTik9LINPmabJfVi0jfVs5sjVS_1l00WpnVTFEuLV@mail.gmail.com>
	<1274890736.4467.574.camel@mulgrave.site>
	<1274891308.1674.1766.camel@laptop>
	<20100526165919.GB2089@elf.ucw.cz>
	<1274893309.1674.1773.camel@laptop>
	<1274894685.4467.758.camel@mulgrave.site>
	<alpine.LFD.2.00.1005261948290.2995@localhost.localdomain>
	<1274898180.4467.925.camel@mulgrave.site>
	<1274948234.14002.27.camel@thorin>
Date: Thu, 27 May 2010 02:07:21 -0700
Message-ID: <AANLkTilk7FX1Y0uWKyMEpf8uxFPBae3X0hGdLLa5oNUa@mail.gmail.com>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: James Bottomley <James.Bottomley@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Pavel Machek <pavel@ucw.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 1:17 AM, Bernd Petrovitsch
<bernd@petrovitsch.priv.at> wrote:
> On Mit, 2010-05-26 at 13:23 -0500, James Bottomley wrote:
>> On Wed, 2010-05-26 at 19:51 +0200, Thomas Gleixner wrote:
> [...]
>> > Darn, _we_ have to deal with that forever as it sets a crappy user
>> > space ABI in stone.
>>
>> I really don't see how it is ... the ABI comes with a switch that allows
>> it to be disabled, so only platforms wishing to use it have to support
>> it.  Even on those platforms that do support it, we can translate most
>
> You completely missed the point: The crappy user interface - and
> interferences with pother subsystems - must be maintained for ages - and
> that is independent if one uses it or not. Even worse if it's not widely
> used.

When (or if) the time comes that suspend is no longer useful, this api
becomes a NOP.

>
>> of it into pm QoS stuff and if one day someone solves the rogue app
>> problem, we can migrate over.
>
> If it's so important for Android and no one else, Android can carry it
> out of tree.
>

This is not only important for Android. If you use suspend on a
current Linux system you run the risk of loosing wakeup events. If you
have wakeup events that you cannot afford to lose your only option is
to never suspend. On some hardware (e.g. x86) the cost of not
suspending is always huge, on other hardware (many ARM SOCs) the cost
is only huge if your apps behave poorly.

-- 
Arve Hjønnevåg
