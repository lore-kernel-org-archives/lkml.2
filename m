Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab2BRQPn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 11:15:43 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:33902 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752635Ab2BRQPk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 11:15:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dwindsor@gmail.com designates 10.60.12.103 as permitted sender) smtp.mail=dwindsor@gmail.com; dkim=pass header.i=dwindsor@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAL1RGDWM0C26YR+GGbguRQd0R3HoPJ5QVyEFkLGFfPqs6wb5Mg@mail.gmail.com>
References: <CAEXv5_gkTsPHDFh+wQqD3P3D-Z+uCN-_1bVyHfHV=u7bS-tgeA@mail.gmail.com>
	<20120216204515.GH20420@outflux.net>
	<20120217002405.GB7746@kroah.com>
	<20120217075945.GA2831@albatros>
	<20120217175445.GC29902@kroah.com>
	<20120217193719.GA4187@albatros>
	<20120217233908.GA24047@dztty>
	<CAL1RGDWM0C26YR+GGbguRQd0R3HoPJ5QVyEFkLGFfPqs6wb5Mg@mail.gmail.com>
Date: Sat, 18 Feb 2012 11:15:39 -0500
Message-ID: <CAEXv5_ioJSAEcvBH6syqgksesTNZ2VU2QTE-XkhXp4vf1jZ1VQ@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: Add overflow protection to kref
From: David Windsor <dwindsor@gmail.com>
To: Roland Dreier <roland@purestorage.com>
Cc: Djalal Harouni <tixxdz@opendz.org>, Vasiliy Kulikov <segoon@openwall.com>,
        kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>,
        Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, pageexec@freemail.hu,
        spender@grsecurity.net, gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 8:44 PM, Roland Dreier <roland@purestorage.com> wrote:
> On Fri, Feb 17, 2012 at 3:39 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
>>> 2) what to do with architectures-loosers?
>> There is lib/atomic64.c but with a static hashed array of raw_spinlocks.
>
> Even leaving aside performance impact of atomic64_t (and probably
> in most cases the performance of kref is not important at all), it is
> unfortunate to bloat the size from 4 bytes to 8 bytes.
>
> It seems much better to have some out-of-line code for overflow
> checking rather than increasing the size of every data structure
> that embeds a kref.
>

kref is mostly a set of operations (init, get, sub, put) to be
performed on an atomic_t object.

>From linux/kref.h:

struct kref {
    atomic_t refcount;
};

Moving overflow protection into kref amounts to placing some
procedural code into kref_get and kref_sub, adding a rather small
constant factor of time, not space, to users of kref.  Introducing
overflow protection doesn't necessitate adding anything to kref for
greater state tracking.

Did you have something else in mind when you suggested a potential
increase in the size of kref?


-- 
PGP: 6141 5FFD 11AE 9844 153E  F268 7C98 7268 6B19 6CC9
