Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab2CEURQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 15:17:16 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64194 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481Ab2CEURP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 15:17:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of levinsasha928@gmail.com designates 10.50.46.194 as permitted sender) smtp.mail=levinsasha928@gmail.com; dkim=pass header.i=levinsasha928@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120305195758.GA25498@redhat.com>
References: <20120305154411.GA29668@redhat.com> <1330972323.2191.74.camel@work-vm>
 <20120305192338.GA30491@redhat.com> <1330977010.2191.84.camel@work-vm> <20120305195758.GA25498@redhat.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 5 Mar 2012 22:16:54 +0200
Message-ID: <CA+1xoqfYbC30dFDOtfAVcr5w0WYAS1ruKFS-rcRAEv2ZqaGW6w@mail.gmail.com>
Subject: Re: WARNING: Adjusting tsc more then 11%
To: Dave Jones <davej@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 9:57 PM, Dave Jones <davej@redhat.com> wrote:
> On Mon, Mar 05, 2012 at 11:50:10AM -0800, John Stultz wrote:
>
>  > >  > > The reports seem to have started around 3.3-rc4.
>  > > thinking about this some more, while the reports starts around rc4, this
>  > > may have been caused by something prior to that, as anyone moving from
>  > > Fedora 16 or earlier to F17 alpha would have jumped quite a kernel version or two.
>  >
>  > Was F16 3.1 based? The warning was added in 3.2, so if you skipped it,
>  > it may not be new behavior then.
>
> initially 3.1 based. We recently pushed out a rebase to 3.2.
> This bug hasn't shown up there (yet?)
>
>  > Ok. Well, just to level set: the warning is informative, and points to
>  > unexpected, but not necessarily unsafe behavior.
>  >
>  > In fact, the risk (where mult is adjusted to be large enough to cause an
>  > overflow) we're warning about have been present 2.6.36 or even possibly
>  > before. The change in 3.2 which added the warning also added a more
>  > conservative mult calculation, so we're less likely to get overflow
>  > prone large mult values.
>  >
>  > So it would be great to get further feedback from folks who are seeing
>  > this warning, so we can really hammer this out, but I don't want the
>  > warning spooking anyone into thinking things are terribly broken.
>
> One of the reports was from someone using vbox. I'm now wondering if
> the other users are using some other flavour of virt. I'll ask.

I've reported this issue with regards to KVM before
(http://permalink.gmane.org/gmane.comp.emulators.kvm.devel/85632) but
according to this thread it's not really KVM specific.

It's easily reproducible using Dave's trinity running inside a KVM guest.
