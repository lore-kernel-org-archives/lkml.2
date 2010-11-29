Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab0K2Fez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 00:34:55 -0500
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:53428 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1749667Ab0K2Fez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 00:34:55 -0500
X-Greylist: delayed 508 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Nov 2010 00:34:54 EST
Subject: Re: [PATCH] Repalce strncmp by memcmp
From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Pavel Vasilyev <pavel@pavlinux.ru>, Ming Lei <tom.leiming@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, yoshfuji@linux-ipv6.org
In-Reply-To: <20101129041359.GA6991@core.coreip.homeip.net>
References: <4CF30B46.4000203@pavlinux.ru>
	 <AANLkTikjDfyWY=Gy7VkdvEGNnYB9kb_iCqNDP7H9W5z4@mail.gmail.com>
	 <4CF319D9.9060102@pavlinux.ru>
	 <20101129041359.GA6991@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-2022-JP"
Organization: USAGI Project
Date: Mon, 29 Nov 2010 14:26:02 +0900
Message-ID: <1291008362.5818.28.camel@takos>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-11-28 (Sun) 20:13 -0800, Dmitry Torokhov wrote:
> On Mon, Nov 29, 2010 at 06:11:21AM +0300, Pavel Vasilyev wrote:
> > On 29.11.2010 05:29, Ming Lei wrote:
> > > Hi,
> > >
> > > 2010/11/29 Pavel Vasilyev <pavel@pavlinux.ru>:
> > >>    This patch replace all strncmp(a, b, c) by  memcmp(a, b, c).
> > >>
> > >> I test on x86_64 (AMD Opteron 285).
> > > In fact, memcmp doesn't handle case of tail of string, so
> > > it is not safe to replace strncmp with memcmp
> > >
> > #include <stdio.h>
> > #include <errno.h>
> > 
> > int main() {
> > 
> >    char *STR = "XXXX\0";
> >    char *XXX = "XXXX";
> 
> Try comparing:
> 
> "XXXX\0YYYY" and
> "XXXX\0ZZZZ"
> 
> and observe the difference.
> 

Yes, if both of the strings are NOT known to have enough length.

It is safe to replace strncmp(a,b,n) with memcmp(a,b,n)
if a or b is/are known to have enough length; strlen(a) >= n ||
strlen(b) >= n.

I think some of the replacements in the original patch are valid,
but for even those valid replacement, I think it is worth doing
that in hot code paths only.

--yoshfuji

