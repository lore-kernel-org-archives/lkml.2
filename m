Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0KZPWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:22:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59461 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab0KZPWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:22:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [RESEND][BUG][PATCH]-rc: USB: yurex: add .llseek fop to file_operations
Date: Fri, 26 Nov 2010 16:22:28 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1+; KDE/4.5.1; x86_64; ; )
Cc: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
References: <4CEE8A99.5020906@gmail.com> <20101125171613.GB18152@suse.de>
In-Reply-To: <20101125171613.GB18152@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011261622.29100.arnd@arndb.de>
X-Provags-ID: V02:K0:p8XVkl3186Ha8PDNeTaDxOSqKQsqxNQTvLftxAF1tHN
 LpTPQXrilLYeBV/a5nL/SK6/EgO3ffQK2GX29qdQDZQBvYvJfp
 BYmX2uAdT1tciLwYXYLX0RgCm7Vn6JEwl5GAs79/NQaqAsPXaZ
 AJxQ62Qy67RyO/N6z9JP/9HtNs8d1rXMTsGig0pBnhoM4ud7tv
 9hV6EdD/Po0TJMSxR1p5Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 November 2010 18:16:13 Greg KH wrote:
> On Fri, Nov 26, 2010 at 01:11:05AM +0900, Tomoki Sekiyama wrote:
> > Hi Greg-KH,
> > Sorry for resending this; To: was not enough.
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=23512
> > 
> > Default llseek operation behavior was changed by the patch named
> > "vfs: make no_llseek the default" after the yurex driver was merged,
> > so the llseek to yurex is now ignored.
> > 
> > This patch add llseek fop with default_llseek to yurex driver
> > to catch up to the change.
> > 
> > Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
> 
> It's in my queue, sorry, been without power and water at home for a few
> days, will catch up on this stuff next week...

I was out most of the week, so I didn't get to look at it either.
Is there an actual bug here caused by having no .llseek function?

As far as I can tell, you don't really want to seek this file
anyway, so the default behaviour of disallowing llseek would actually
make more sense.

	Arnd
