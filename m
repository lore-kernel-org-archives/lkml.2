Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab2CETu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 14:50:27 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51165 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488Ab2CETu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 14:50:26 -0500
Message-ID: <1330977010.2191.84.camel@work-vm>
Subject: Re: WARNING: Adjusting tsc more then 11%
From: John Stultz <john.stultz@linaro.org>
To: Dave Jones <davej@redhat.com>
Cc: Fedora Kernel Team <kernel-team@fedoraproject.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 05 Mar 2012 11:50:10 -0800
In-Reply-To: <20120305192338.GA30491@redhat.com>
References: <20120305154411.GA29668@redhat.com>
	 <1330972323.2191.74.camel@work-vm> <20120305192338.GA30491@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030519-9360-0000-0000-0000043E24C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 14:23 -0500, Dave Jones wrote:
> On Mon, Mar 05, 2012 at 10:32:03AM -0800, John Stultz wrote:
>  > On Mon, 2012-03-05 at 10:44 -0500, Dave Jones wrote:
> 
>  > > any idea what could have changed to start tripping that up ?
>  > > 
>  > > The reports seem to have started around 3.3-rc4.
>  > 
>  > Huh. No I don't know what would have started causing such a warning. I
>  > had expected that there would be some edge hardware that might trip that
>  > warning, but I'd expect the noise to start there w/ 3.2 after it was
>  > introduced. There's only been spelling & comment changes to the
>  > timekeeping core in the 3.3-rc series.
> 
> thinking about this some more, while the reports starts around rc4, this
> may have been caused by something prior to that, as anyone moving from
> Fedora 16 or earlier to F17 alpha would have jumped quite a kernel version or two.

Was F16 3.1 based? The warning was added in 3.2, so if you skipped it,
it may not be new behavior then.

>  > Do you know if this is an occasional thing on any of the affected
>  > hardware, or if it happens after every reboot?
> 
> Out of all the people running the Fedora 17 alpha, this has only shown
> up those four times, so it does seem to be a rare thing.
> I suspect we'll get more instances of it as more people start testing.
> 
> Three of the reporters noted that it happened on boot.
> 
>  > Are any of the reported boxes systems you have access to in order to
>  > reproduce?
> 
> unfortunately not.

Ok. Well, just to level set: the warning is informative, and points to
unexpected, but not necessarily unsafe behavior.

In fact, the risk (where mult is adjusted to be large enough to cause an
overflow) we're warning about have been present 2.6.36 or even possibly
before. The change in 3.2 which added the warning also added a more
conservative mult calculation, so we're less likely to get overflow
prone large mult values.

So it would be great to get further feedback from folks who are seeing
this warning, so we can really hammer this out, but I don't want the
warning spooking anyone into thinking things are terribly broken.

thanks
-john






