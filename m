Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab1FPR4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 13:56:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51565 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758503Ab1FPR4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 13:56:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the packed attribute
Date: Thu, 16 Jun 2011 19:55:50 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Alexander Holler <holler@ahsoftware.de>, gregkh@suse.de,
        Rabin Vincent <rabin@rab.in>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <Pine.LNX.4.44L0.1106161308310.2204-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106161308310.2204-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106161955.50972.arnd@arndb.de>
X-Provags-ID: V02:K0:B9sUtfnrYpKR+jU04IJ2XOILk+ZOIJDuAkgK0bf4hrk
 6RXURPBHkP7yWyjPl0DAUH7XTUz5IGsB42IbJGX+nOJAhMbaRN
 INEDXOwwjJ0xYM+TftfuBYC+vXYqgPoWE6Ko14c3cBGBu90YeD
 obv/JyZV7kDHI5u7bVx7CWF2t/yGZ6oApJXfYN6TkkphCs83n+
 bwtwxnBcT1ogGwW29oRpg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 June 2011, Alan Stern wrote:
> 
> On Thu, 16 Jun 2011, Alexander Holler wrote:
> 
> > In commit 139540170d9d9b7ead3caaf540f161756b356d56 the attribute
> > packed is removed from the structs which are used to access the EHCI-registers.
> > 
> > This is done to circumvent a problem with gcc 4.6, which might access members of
> > packed structs on a byte by byte basis. But using packed, aligned(4) fixes that
> > too and is imho the better solution. Otherwise (without packed) the compiler would be free
> > to choose whatever alignment he thinks fits best, which might be e.g. 8-byte on 64-bit machines.
> 
> Is that really true?

No.

> I thought the compiler was not allowed to insert 
> padding if the natural alignment of the data types didn't require any.

It's architecture dependent. The alignment of the structure is the maximum alignment
of its members, so it gets to be 8 bytes if there is a 64 bit member in the struct
on most architectures, but 4 bytes on x86.

	Arnd
