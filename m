Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab0FHI56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 04:57:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53560 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab0FHI54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 04:57:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qMfwNLhXlA6BbJNQuPKoPxTgf2zAXR2bfvkA5+HoXddbb1QGAPG2hgJvGdym4o9n5H
         zEUiry8PXY1RvituUz0qGeaamM1WrHDlTfFqOrx2jWJxnyr7iZP7TriNfoO2SOhn3sL4
         UFmZPMn/h5NJbl/+i3xleU3IlZlpeZhMR/TqM=
Subject: Re: [PATCH 2/2] mmc: fix mmc card disappearence on resume on ricoh
	mmc controllers
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Philip Langdale <philipl@overt.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <648846745cc9a3a023fa12f306caabf6@localhost>
References: <1275859475.3151.4.camel@maxim-laptop>
	 <1275859731-2898-2-git-send-email-maximlevitsky@gmail.com>
	 <648846745cc9a3a023fa12f306caabf6@localhost>
Content-Type: text/plain
Date: Tue, 08 Jun 2010 11:57:46 +0300
Message-Id: <1275987466.30596.13.camel@dell16>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-06 at 19:22 -0400, Philip Langdale wrote:
> On Mon,  7 Jun 2010 00:28:51 +0300, Maxim Levitsky
> <maximlevitsky@gmail.com> wrote:
> > The reason was that it takes time for controller to detect the card.
> > So wait a bit for the card to appear.
> > In worst case scenario, when you suspend the system with mmc card,
> > and actually remove it, the resume will be delayed maximum by 2 seconds
> 
> I suspect it's probably sending an SD id command to the card and then that
> has to time out on MMC cards.
> 
> Acked-by: Philip Langdale <philipl@overt.org>

Thanks!

Note that I spoke too soon about it being perfect
While mmc card that stays in slot now works fine, a card that is
inserted while system is asleep, is detected, but then controller
becomes confused, so card doesn't work. A reinsert does help though.
Overall I need to work around some unusual delays imposed by controller
due to unusual card detection.
I'll sort that out eventually (and hope not to bring much ugliness to
sdhci{,-pci}.c

I think I update this patch to address both issues.

Best regards,
	Maxim Levitsky

