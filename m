Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab2BRQkw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 11:40:52 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41479 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2BRQkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 11:40:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of segooon@gmail.com designates 10.204.129.86 as permitted sender) smtp.mail=segooon@gmail.com; dkim=pass header.i=segooon@gmail.com
Date: Sat, 18 Feb 2012 20:35:56 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-hardening@lists.openwall.com
Cc: Roland Dreier <roland@purestorage.com>, Djalal Harouni <tixxdz@opendz.org>,
        Kees Cook <keescook@chromium.org>,
        Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, pageexec@freemail.hu,
        spender@grsecurity.net, gregkh@linuxfoundation.org
Subject: Re: [kernel-hardening] Re: Add overflow protection to kref
Message-ID: <20120218163556.GA11640@albatros>
References: <CAEXv5_gkTsPHDFh+wQqD3P3D-Z+uCN-_1bVyHfHV=u7bS-tgeA@mail.gmail.com>
 <20120216204515.GH20420@outflux.net>
 <20120217002405.GB7746@kroah.com>
 <20120217075945.GA2831@albatros>
 <20120217175445.GC29902@kroah.com>
 <20120217193719.GA4187@albatros>
 <20120217233908.GA24047@dztty>
 <CAL1RGDWM0C26YR+GGbguRQd0R3HoPJ5QVyEFkLGFfPqs6wb5Mg@mail.gmail.com>
 <CAEXv5_ioJSAEcvBH6syqgksesTNZ2VU2QTE-XkhXp4vf1jZ1VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXv5_ioJSAEcvBH6syqgksesTNZ2VU2QTE-XkhXp4vf1jZ1VQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 18, 2012 at 11:15 -0500, David Windsor wrote:
> On Fri, Feb 17, 2012 at 8:44 PM, Roland Dreier <roland@purestorage.com> wrote:
> > On Fri, Feb 17, 2012 at 3:39 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> >>> 2) what to do with architectures-loosers?
> >> There is lib/atomic64.c but with a static hashed array of raw_spinlocks.
> >
> > Even leaving aside performance impact of atomic64_t (and probably
> > in most cases the performance of kref is not important at all), it is
> > unfortunate to bloat the size from 4 bytes to 8 bytes.
> >
> > It seems much better to have some out-of-line code for overflow
> > checking rather than increasing the size of every data structure
> > that embeds a kref.
> >
> 
> kref is mostly a set of operations (init, get, sub, put) to be
> performed on an atomic_t object.
> 
> >From linux/kref.h:
> 
> struct kref {
>     atomic_t refcount;
> };
> 
> Moving overflow protection into kref amounts to placing some
> procedural code into kref_get and kref_sub, adding a rather small
> constant factor of time, not space, to users of kref.  Introducing
> overflow protection doesn't necessitate adding anything to kref for
> greater state tracking.
> 
> Did you have something else in mind when you suggested a potential
> increase in the size of kref?

4 bytes => 8 bytes of atomic_t => atomic64_t in case we increase the refcounter
range to make it impossible to overflow the refcounter

compared to

add checks into kref_get()/atomic_inc*() without changing refcounter ranges.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
