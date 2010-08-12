Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451Ab0HLCnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 22:43:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34822 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759385Ab0HLCny convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 22:43:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=N8b1lnInE8Ye783cCjFyIlP90qEzK+Q2aTDaC0LBgVwKXaDucUjkjXYPIGzwEIQYSD
         iLhQX5Vok+IU2unVxtp4mNasbdtL7r3fTZr9jYvA3oLcMNV9D5sXI5fy7Qc6MMcwVp/R
         YwmIH0wHbhfsD2X2MntbqrbKkwVz5ijhl8ngg=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] ARM: Fix gen_nand probe structures contents
Date: Thu, 12 Aug 2010 04:43:24 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "kernel@wantstofly.org" <kernel@wantstofly.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "kaloz@openwrt.org" <kaloz@openwrt.org>,
        "khc@pm.waw.pl" <khc@pm.waw.pl>, "tj@kernel.org" <tj@kernel.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>
References: <1281575694-17551-1-git-send-email-marek.vasut@gmail.com> <1281576112.12475.15.camel@localhost>
In-Reply-To: <1281576112.12475.15.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008120443.24749.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Čt 12. srpna 2010 03:21:52 David Woodhouse napsal(a):
> On Thu, 2010-08-12 at 02:14 +0100, Marek Vasut wrote:
> > These three platforms didn't properly fill nr_chips in gen_nand
> > registration and
> > therefore depended on gen_nand bug fixed by the following patch:
> > 
> > "mtd: gen_nand: fix support for multiple chips"
> > 
> > Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> 
> Thanks. I've applied that to the mtd-2.6.git tree, which has a few
> straggling commits I'll be asking Linus to pull shortly.
> 
> In case there are any more, would you care to complement it with a check
> in the driver that detects the nonsensical case of nr_chips == 0,
> assumes it means 1, and also warns about it?

I checked whole arch-arm and there are no more. nr_chips check would be a nice 
thing, I was thinking of it already when I sent the first patch. I just checked 
the other archs and there are more breaks. I'll implement the check in a 
separate patch.
