Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab1ERQIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:08:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55560 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122Ab1ERQIM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:08:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Qy9P1SwGAPCNOUN9yzR/GPF7BOGwC7qfcE3ppty2H3RwurA/0bS7FUmcdHERQVXXjV
         mLX6Hvf+GXYfna6pRCayi5UjfeZZdpcTcn8H04sn3I319xGLxSlWprxdP2JKtym6zVu3
         yGRm8AqAKDoJuYPe5cnhYf4PVW79rJ1jkdFy4=
From: Christian Lamparter <chunkeey@googlemail.com>
To: =?iso-8859-1?q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
Subject: Re: [RFC v2] lis3lv02d: avoid divide by zero due to unchecked register read
Date: Wed, 18 May 2011 18:03:08 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc7-wl+; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201105160046.31019.chunkeey@googlemail.com> <201105181747.12356.chunkeey@googlemail.com> <4DD3EC22.7060907@tremplin-utc.net>
In-Reply-To: <4DD3EC22.7060907@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105181803.08972.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 May 2011 17:56:18 Éric Piel wrote:
> Op 18-05-11 17:47, Christian Lamparter schreef:
> > On Tuesday 17 May 2011 23:46:00 Éric Piel wrote:
> >> Op 16-05-11 23:36, Christian Lamparter schreef:
> >>> On Monday 16 May 2011 13:16:46 Éric Piel wrote:
> >>> Do you know how "volatile" this data rate is? If it never changes
> >>> [at least it doesn't here?] then why not read it once in init_device
> >>> and store it in the device context?
> >> It is not normally changing, normally it is set just at init/unsuspend
> >> (where the bios can also interfere sometimes) and when the user changes
> >> it.
> > Uh, "bios can also interfere"... this sounds very bad. At least for
> > my x41t the bios doesn't care about hdaps once the OS is running.
> >
> >> So definitely within the same function it's not going to suddenly
> >> change.
> > a SMM can happen at any time and if a faulty BIOS [likely, since I got
> > a new laptop] is what caused the crash, I wouldn't bet on "const within
> > a function context".
> Yes, at least on the HP laptop I have the bios enjoys re-initialising 
> the hardware at some default value whenever suspend/resume happens.
> 
> >> We could avoid calculating/checking it twice in
> >> lis3lv02d_selftest(). Care to do a third version with this little clean up?
> > I have my doubts, but ok if you say so... Just one thing: need to do some Q&A
> > on the code above, I haven't tested it extensively yet.
> I didn't know about the SMM... well, then let's keep the code as is.
> 
> I'll try to test it on my laptop in the coming days. On which hardware 
> have you tested it?
I've a dv6-6003eg, it's fairly new.

Regards,
	Chr
