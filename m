Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab0CWD6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 23:58:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751717Ab0CWD6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 23:58:37 -0400
Date: Mon, 22 Mar 2010 20:57:04 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>, linux-kernel@vger.kernel.org,
       David.Woodhouse@intel.com, dwmw2@infradead.org, eric@anholt.net,
       ben@decadent.org.uk, gregkh@suse.de
Subject: Re: [PATCH] intel-agp.c: Fix crash when accessing nonexistent GTT 
 entries in i915
Message-Id: <20100322205704.ac4cd9ae.akpm@linux-foundation.org>
In-Reply-To: <ca2dc2821003210830h2025df79r477cca7d81ddd28d@mail.gmail.com>
References: <1268258994.2183.14.camel@carter>
	<ca2dc2821003102331x3d1a7a0fgadb63612e49f77db@mail.gmail.com>
	<20100311083404.GG6896@zhen-devel.sh.intel.com>
	<ca2dc2821003110754r65ab170at39a61fb11fa285e0@mail.gmail.com>
	<20100319132723.118cc16a.akpm@linux-foundation.org>
	<ca2dc2821003200604m7c8cdea4r64ab8c98e7ec8242@mail.gmail.com>
	<20100321135836.GA11661@zhen-devel.sh.intel.com>
	<ca2dc2821003210830h2025df79r477cca7d81ddd28d@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Mar 2010 16:30:20 +0100 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:

> On Sun, Mar 21, 2010 at 2:58 PM, Zhenyu Wang <zhenyuw@linux.intel.com> wrote:
> > On 2010.03.20 14:04:56 +0100, Miguel Ojeda wrote:
> >> On Fri, Mar 19, 2010 at 9:27 PM, Andrew Morton
> >> <akpm@linux-foundation.org> wrote:
> >> > On Thu, 11 Mar 2010 16:54:26 +0100
> >> > Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
> >> >
> >> >> Attached dmesg, lspci -vv, config and xorg.
> >> >>
> >> >> When the X server crashes, the kernel does not report anything
> >> >
> >> > This seems to have gone all quiet?
> >>
> >> It seems so, I was about to ping Zhenyu.
> >
> > Could you try recent X.org intel driver release? Your failure X log
> > showed some pretty old UMS driver's render flush time out message,
> > I think whose version never has been well tested with new kms/gem stuff.
> >
> 
> Sure. Debian Stable got version 2.3.
> 
> >>
> >> >
> >> > As this was a 2.6.32->2.6.32.4 regression, I assume that it's also a
> >> > 2.6.32->2.6.33 regression?
> >>
> >> Yep. All kernels I tested since 2.6.32.4 crash, including 2.6.32.10,
> >> 2.6.33 and 2.6.34-rc1. See my original message for more details about
> >> the crash.
> >>
> >
> > Could you bisect? I doubt it's caused by David's patch, as if it is, you
> > will have trouble at early agp init time, instead of current problem looks
> > like something causing rendering hang..and I can't think of how mapping GTT
> > to a scratch page could cause problem in case GTT bar is truely 256K.
> 
> I bisected in order to find the commit 5877960869333e42ebeb733e8d9d5630ff96d350.

I have no 5877960869333e42ebeb733e8d9d5630ff96d350 here.  This is why
we ask that people always identify patches by both the hash and the
full title..


> I don't know if such commit is really the true problem (does not seem
> so if you are right); however, it is the commit that breaks the X
> server as I stated in the original message.

