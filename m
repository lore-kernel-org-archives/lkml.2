Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab2BRBpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 20:45:21 -0500
Received: from na3sys010aog109.obsmtp.com ([74.125.245.86]:50607 "HELO
	na3sys010aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751997Ab2BRBpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 20:45:20 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of roland@purestorage.com designates 10.216.135.193 as permitted sender) smtp.mail=roland@purestorage.com; dkim=pass header.i=roland@purestorage.com
MIME-Version: 1.0
In-Reply-To: <20120217233908.GA24047@dztty>
References: <CAEXv5_gkTsPHDFh+wQqD3P3D-Z+uCN-_1bVyHfHV=u7bS-tgeA@mail.gmail.com>
 <20120216204515.GH20420@outflux.net> <20120217002405.GB7746@kroah.com>
 <20120217075945.GA2831@albatros> <20120217175445.GC29902@kroah.com>
 <20120217193719.GA4187@albatros> <20120217233908.GA24047@dztty>
From: Roland Dreier <roland@purestorage.com>
Date: Fri, 17 Feb 2012 17:44:57 -0800
Message-ID: <CAL1RGDWM0C26YR+GGbguRQd0R3HoPJ5QVyEFkLGFfPqs6wb5Mg@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: Add overflow protection to kref
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com,
        Kees Cook <keescook@chromium.org>,
        Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, David Windsor <dwindsor@gmail.com>,
        pageexec@freemail.hu, spender@grsecurity.net,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 3:39 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
>> 2) what to do with architectures-loosers?
> There is lib/atomic64.c but with a static hashed array of raw_spinlocks.

Even leaving aside performance impact of atomic64_t (and probably
in most cases the performance of kref is not important at all), it is
unfortunate to bloat the size from 4 bytes to 8 bytes.

It seems much better to have some out-of-line code for overflow
checking rather than increasing the size of every data structure
that embeds a kref.

Greg, I'm not sure why you're opposed to adding this checking...
it's pretty clear that buggy error paths that forget to do a put are
pretty common and will continue to be common in new code, and
making them harder to exploit seems pretty sane to me.

What's the downside?

 - R.
