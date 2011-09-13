Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab1IMUMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 16:12:07 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54854 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420Ab1IMUMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 16:12:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Salter <msalter@redhat.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/24] C6X: devicetree
Date: Tue, 13 Sep 2011 22:11:33 +0200
Message-ID: <2208047.tv5XC4ZmAf@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <CACxGe6tVafwVN6vdU7sCxL5JM7+as0bp_AaHaGAyE9+eTgR5Tw@mail.gmail.com>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com> <201109131733.59700.arnd@arndb.de> <CACxGe6tVafwVN6vdU7sCxL5JM7+as0bp_AaHaGAyE9+eTgR5Tw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ED7Rqs9K9t4HAFRC1vhZUjQqRkhDucWbM4dPeQEeTbg
 6+y1F0S//DV9xB5uuWsIGJthTIgTibHCkkdiNkrXGizCgH5bbi
 zaRh2lxTjyaZA9hXs+Q6r4cYufi3cFf0KnkBDuXy+URNEDPlfP
 bjzBl528vmI4rQQZhLiHMrT9qE3cFW9W396Q+OmzyB1mGIpnek
 A1KDVGoWRMw0X1oibDSh/I1fVDEPrblrOa8jBxPyDObTnB+27e
 6fBMAdg69LKD89BAdk4TyNIcGKjEDxPry/s33F38EeP+sH9Bxc
 NSLwrQBsePtmfldLze5Scihu98uLb9sUtBb08bLWAVnSJ13c29
 ZiQnpTBTP74g8uRKaM0c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 September 2011 11:54:36 Grant Likely wrote:
> >
> > I guess it still depends, it's probably a grey area. If the register layout
> > is the same on all c6x cores and it's only for core stuff, there is no need
> > to put it in the device tree. If you have multiple soc (off-core) devices
> > being controlled through the registers, or the numbers vary a lot between
> > different chips, I would put all of them into the device tree.
> 
> It's an interrupt controller.  There still needs to be a node to act
> as the interrupt-parent and specify #interrupt-cells.

I was talking about whether the interrupt controller node needs to have
a "regs" property or not. If the register space is similar to generic
MMIO registers, it should have one, like all other users of these
registers. If it's more like ARM's coprocessor extension, it probably
should not.

	Arnd
