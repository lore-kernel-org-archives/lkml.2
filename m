Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934223Ab0EZJyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 05:54:40 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:61390 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933566Ab0EZJyi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 05:54:38 -0400
MIME-Version: 1.0
In-Reply-To: <1274866402.5882.5051.camel@twins>
References: <Pine.LNX.4.44L0.1005251647530.1634-100000@iolanthe.rowland.org>
	 <201005252344.37639.rjw@sisk.pl>
	 <AANLkTimL5rU5lALezEZVCwdcZL85tVahhsTibdpq9s-Y@mail.gmail.com>
	 <1274863342.5882.4850.camel@twins>
	 <20100526112303.3fef15a4@schatten.dmk.lab>
	 <1274866402.5882.5051.camel@twins>
Date: Wed, 26 May 2010 02:54:37 -0700
Message-ID: <AANLkTil9ZtMFxTfE6ITiFNOl4S1k3Lvdp5BPgGX7LJhw@mail.gmail.com>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Florian Mickler <florian@mickler.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 2:33 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-05-26 at 11:23 +0200, Florian Mickler wrote:
>
>> There is polling, because the suspend manager in userspace doesn't have
>> the whole picture. i.e. it doesn't know if a suspend will be
>> successfull.
>> So for aggressive suspending as a powersave-feature you need to poll
>> (i.e. retry upon failure). because you don't want to stay unsuspended.
>
> Clearly if it fails, there something to be done, right? So whoever does
> the thing will communicate with the suspend manager that it's going to
> do and has finished doing its thing, at which point it will try again.
>

If you are talking about user-space code here, then that does not
work. Not all kernel events that need to block suspend make it to
user-space.

> That's event driven, not polled.
>
> Also, if you want you can keep the kernel-side auto-suspend side, and
> have the suspend manager clear on !0 and re-establish the auto-suspend
> state on 0.
>
> But you really don't need this device thingy.
>

I'm not sure what you are proposing that we use instead. Both
user-space and kernel code needs to block suspend. If we don't have
suspend blockers in the kernel then user-space needs to poll when a
driver blocks suspend by returning an error from its suspend hook.

-- 
Arve Hjønnevåg
