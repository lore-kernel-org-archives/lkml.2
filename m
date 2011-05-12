Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab1ELLwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 07:52:42 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56619 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240Ab1ELLwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 07:52:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cntDCmJYlxnRkAHbxnVyPbvwPmfrStBnBAwiAQV5lvQYX2uBPMRw2MSiYnpACC/aOe
         aJevtlRaeG8UsgP1nvR+Y6mDbMQ+j1NE2XtHrwK1R9G56bmIicoMdOZghqKCwqORNGQD
         m0E8XlxzuedSKYFSBuHYOCdfAzSf9XMuCnetw=
Subject: Re: [PATCH] mtd: m25p80: Use CFI to identify unknown flash chips
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Kevin Cernekee <cernekee@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <97ed2bb63176b59ee2b283be69f0c6a4@localhost>
References: <97ed2bb63176b59ee2b283be69f0c6a4@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 14:49:17 +0300
Message-ID: <1305200957.2713.99.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-08 at 16:16 -0700, Kevin Cernekee wrote:
> Many of the newer SPI flash devices support both JEDEC and CFI queries.
> While JEDEC RDID only returns the device ID, CFI provides the device
> size, eraseblock size, and other information.  In some cases this may
> allow previously unknown devices to be supported without adding yet
> another entry to m25p_ids[].
> 
> This patch replaces jedec_probe() with a new cfi_probe() function.  The
> existing JEDEC probe/match logic is attempted first, and CFI is only used
> if no match is found.
> 
> Additionally, platform_data.type may now specify "auto", which instructs
> m25p80.c to autodetect the chip type rather than trying to match a
> specific entry.  In some situations, board manufacturers have multiple
> sources for flash parts (usually with identical geometries), but do not
> know in advance which specific part will be used on a given board.  The
> "auto" parameter allows the BSP to indicate this to the driver, so that
> the driver does not warn the user about a flash device mismatch.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> ---
>  drivers/mtd/devices/m25p80.c |  181 ++++++++++++++++++++++++++++--------------
>  1 files changed, 121 insertions(+), 60 deletions(-)

Could you please send a patch which cleanly applies to l2-mtd-2.6.git?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

