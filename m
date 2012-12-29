Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab2L2IQI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 03:16:08 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:41144 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab2L2IQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 03:16:05 -0500
Date: Sat, 29 Dec 2012 00:07:43 -0800
From: Jonathan Nieder <jrnieder@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kees Cook <keescook@chromium.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ 016/173] use clamp_t in UNAME26 fix
Message-ID: <20121229080742.GD18903@elie.Belkin>
References: <20121228190330.025298996@decadent.org.uk>
 <20121228190333.385175939@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20121228190333.385175939@decadent.org.uk>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings wrote:

> The min/max call needed to have explicit types on some architectures
> (e.g. mn10300). Use clamp_t instead to avoid the warning:
> 
>   kernel/sys.c: In function 'override_release':
>   kernel/sys.c:1287:10: warning: comparison of distinct pointer types lacks a cast [enabled by default]
>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
[...]
> -		copy = min(sizeof(buf), max_t(size_t, 1, len));

I don't understand how this happens given that v2.6.36-rc1~68
(MN10300: Fix size_t and ssize_t, 2010-08-12) was supposed to fix this
kind of thing.  Doesn't sizeof(buf) have type size_t already (C99
§6.5.3.4 "the sizeof operator" ¶4)?

What version of gcc produces this warning?

Puzzled,
Jonathan
