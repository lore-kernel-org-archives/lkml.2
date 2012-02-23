Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab2BWWMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:12:12 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46874 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab2BWWMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:12:10 -0500
MIME-Version: 1.0
In-Reply-To: <20120223215242.GA1306@1wt.eu>
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org>
 <20120222211928.GA4448@kroah.com> <CA+55aFz0pOO6j9s3Gs2UJLM4zm8SuPgi5iUiVAaPCp9Xh2Pvjw@mail.gmail.com>
 <20120222213253.GA25150@kroah.com> <20120223200905.GA5475@kroah.com>
 <4F46A1C4.90506@zytor.com> <20120223204832.GA30322@kroah.com>
 <4F46A6EC.8050804@zytor.com> <20120223211016.GA16275@kroah.com> <20120223215242.GA1306@1wt.eu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Feb 2012 14:11:48 -0800
X-Google-Sender-Auth: AoSNS0Pc-eE2U24L5OhLla-psnA
Message-ID: <CA+55aFyxB4kmmSOKDSRkAkaRx=G7o7JnuUGBu3_WVr9KbpWWYQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
To: Willy Tarreau <w@1wt.eu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 1:52 PM, Willy Tarreau <w@1wt.eu> wrote:
>
> I would test this too, but apart from ensuring my kernel still boots,
> how do I ensure the patches do really fix what the ought to fix ? I
> must admit I didn't catch the initial issue they were supposed to fix
> unfortunately :-/

Almost nobody did.

This only happens on modern CPU's that support the new AES-NI
instructions, and only with a 32-bit kernel (although the very
unlikely preemption issues can happen on x86-64 too). And you need to
have the AES instructions called from interrupts, which probably only
happens with the mac80211 wireless networking stack.

And even then you need WPA2 to trigger it (I guess AES is sometimes
used with "extended WPA1" too, but I dunno).

So it's not impossible to trigger, but you do need to have a fairly
recent CPU that happily runs in 64-bit mode, and install a 32-bit
system on it. And it needs to use the right wireless setup.

It's possible that the right solution for really older kernels is just
to say that AES_NI depends on X86_64.

                      Linus
