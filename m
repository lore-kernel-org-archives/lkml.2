Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393Ab1CWU6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:58:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933284Ab1CWU6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:58:43 -0400
Date: Wed, 23 Mar 2011 13:58:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stuart Swales <stuart.swales.croftnuisk@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adfs: add hexadecimal filetype suffix option
Message-Id: <20110323135835.0c2e296c.akpm@linux-foundation.org>
In-Reply-To: <AANLkTimpYyErnvEjSCevMCcKTW5ffyi9V5EB3U8RwuBG@mail.gmail.com>
References: <4D2DEDDB.1070605@gmail.com>
	<20110119154915.a0bb2878.akpm@linux-foundation.org>
	<AANLkTimpYyErnvEjSCevMCcKTW5ffyi9V5EB3U8RwuBG@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011 21:36:48 +0100
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Thu, Jan 20, 2011 at 00:49, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 12 Jan 2011 18:07:23 +0000
> > Stuart Swales <stuart.swales.croftnuisk@gmail.com> wrote:
> >> From: Stuart Swales<stuart.swales.croftnuisk@gmail.com>
> 
> >> +static inline int append_filetype_suffix(char *buf, __u16 filetype)
> >> +{
> >> + __ __ if ((__u16) -1 == filetype)
> >
> > unneeded cast.
> 
> My compiler tends to disagree. On current mainline, it says:
> 
> fs/adfs/adfs.h: In function ___append_filetype_suffix___:
> fs/adfs/adfs.h:115: warning: comparison is always false due to limited
> range of data type
> 

hm, OK, I'll add a cast.

The code seems a bit fishy - it wants 0xffff but the comment says it's
handling a 12-bit quantity.  Obviously the all-ones pattern has some
magical out-of-band meaning here, but it is not explained what that
meaning *is*.  Perhaps that is described elsewhere.

