Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab1FPRKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 13:10:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35144 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756657Ab1FPRJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 13:09:59 -0400
Date: Thu, 16 Jun 2011 13:09:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alexander Holler <holler@ahsoftware.de>
cc: gregkh@suse.de, Rabin Vincent <rabin@rab.in>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing
 the packed attribute
In-Reply-To: <1308241030-15201-1-git-send-email-holler@ahsoftware.de>
Message-ID: <Pine.LNX.4.44L0.1106161308310.2204-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011, Alexander Holler wrote:

> In commit 139540170d9d9b7ead3caaf540f161756b356d56 the attribute
> packed is removed from the structs which are used to access the EHCI-registers.
> 
> This is done to circumvent a problem with gcc 4.6, which might access members of
> packed structs on a byte by byte basis. But using packed, aligned(4) fixes that
> too and is imho the better solution. Otherwise (without packed) the compiler would be free
> to choose whatever alignment he thinks fits best, which might be e.g. 8-byte on 64-bit machines.

Is that really true?  I thought the compiler was not allowed to insert 
padding if the natural alignment of the data types didn't require any.

Alan Stern

