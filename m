Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab1FPUUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:20:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56424 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407Ab1FPUUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:20:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the packed attribute
Date: Thu, 16 Jun 2011 22:20:01 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Alexander Holler <holler@ahsoftware.de>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin@rab.in>
References: <Pine.LNX.4.44L0.1106161541260.1697-100000@iolanthe.rowland.org> <4DFA634D.6000907@ahsoftware.de>
In-Reply-To: <4DFA634D.6000907@ahsoftware.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106162220.02185.arnd@arndb.de>
X-Provags-ID: V02:K0:2BaHJXMPeoWJzOevAfhacAxnJ2sWwTVLosxM/9tplZd
 EkUdF77JNuBF47LXIfM/wUb6QpFoUMQFnyvBcxMCTn5Evuuccg
 GtFsTRhrhoRVDzm0DZ87vNuLUwH8tnWl8ObbD2T4GqwSeNgu2v
 J9+0AVVf+K2oelARnutHXmED8x3YgJZcZ0UAeOyQMWWwzYZHxf
 e3X+HonaT80JczX9A+rlA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 June 2011 22:10:53 Alexander Holler wrote:
> Using packed doesn't seem to be necessary (at least not with those 
> versions of gcc I'm using here), I've tried both versions (on arm, 
> without packed and with packed, aligned(4)) and both are working. I've 
> only posted the patch because I found the usage of packed, aligned(4) 
> much clearer than without packed. And It might help avoiding such 
> discussions like this with people like me who aren't that deep involved 
> in gcc-specific implementation details. ;)
> 
> Anyway, feel free to nack that patch. I don't really care and just 
> thought I should post it (e.g. as an alternative to removing that packed).

At least I would be happier without the patch. I'm trying to convince
people to not use these attributes unless required because too much
harm is done when they are used without understanding the full
consequences. I also recommend using __packed as localized as possible,
i.e. set it for the members that need it, not the entire struct.

I agree that your patch is harmless, it's just the opposite of
a cleanup in my opinion.

	Arnd
