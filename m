Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549Ab1CWU4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:56:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40781 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933394Ab1CWU4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:56:42 -0400
Date: Wed, 23 Mar 2011 20:56:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stuart Swales <stuart.swales.croftnuisk@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adfs: add hexadecimal filetype suffix option
Message-ID: <20110323205637.GB22723@ZenIV.linux.org.uk>
References: <4D2DEDDB.1070605@gmail.com>
 <20110119154915.a0bb2878.akpm@linux-foundation.org>
 <AANLkTimpYyErnvEjSCevMCcKTW5ffyi9V5EB3U8RwuBG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimpYyErnvEjSCevMCcKTW5ffyi9V5EB3U8RwuBG@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 09:36:48PM +0100, Geert Uytterhoeven wrote:
> On Thu, Jan 20, 2011 at 00:49, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 12 Jan 2011 18:07:23 +0000
> > Stuart Swales <stuart.swales.croftnuisk@gmail.com> wrote:
> >> From: Stuart Swales<stuart.swales.croftnuisk@gmail.com>
> 
> >> +static inline int append_filetype_suffix(char *buf, __u16 filetype)
> >> +{
> >> + ?? ?? if ((__u16) -1 == filetype)
> >
> > unneeded cast.
> 
> My compiler tends to disagree. On current mainline, it says:
> 
> fs/adfs/adfs.h: In function ???append_filetype_suffix???:
> fs/adfs/adfs.h:115: warning: comparison is always false due to limited
> range of data type

And it's absolutely right - unsigned short it promoted to int as part of
usual arithmetic conversions and the value is not changed.  And it's *not*
going to be equal to -1.
