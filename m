Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab1IHP0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 11:26:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64999 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab1IHP0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 11:26:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: dedekind1@gmail.com
Subject: Re: [PATCHv3] UBI: new module ubiblk: block layer on top of UBI
Date: Thu, 8 Sep 2011 17:26:00 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: david.wagner@free-electrons.com,
        "linux-mtd" <linux-mtd@lists.infradead.org>,
        "linux-embedded" <linux-embedded@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        David Woodhouse <dwmw2@infradead.org>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com> <1315280704.19067.14.camel@sauron> <1315282208.19067.24.camel@sauron>
In-Reply-To: <1315282208.19067.24.camel@sauron>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109081726.00769.arnd@arndb.de>
X-Provags-ID: V02:K0:8dZxGp2zrSbJ0WEtOLIXElXnLme7G3isLHs2sXiE6Nu
 YpO9MSmG1mfIFRQKyZuYZmNfwyUZ9DQoL19PdqDT+3sOhU8Wca
 mRnCVi6n5pDw3I7pJv5a88ZKLGMv6X5QL6dviCve9QR4/F0tNY
 97Fes4JdSP0q6jsRVDftdr6ysxNRSQCW71C14mT0r97AO6tGkX
 4SPFmAzUkJOTXZjGHjBGusIOZZG6x5h0tJGnMx2tqWAUxbHz0u
 0o/8ZecdJQ2wK66xV3837ESq6GN4ZWIE3/zBNKHoXfSrOFXAaW
 4EbcjR4YM1I47OXuG5yQvB7v95bYaQsRSGIFSrVQAbCb/CumyI
 a/Ab1XNQYcKF0kNgraa8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 September 2011, Artem Bityutskiy wrote:
> Not sure about the bus approach - David, could you take a look at it
> please? If we can handle errors there - then we could indeed re-use the
> UBI control device. We could even re-use the ioctl data structures for
> UBI volumes creation/removal - we have plenty of space there reserved
> for future extensions.

I would generally recommend using new ioctl commands. ioctl numbers
are cheap, but complexity in data structures is not, because every
user who wants to deal with the data structures has to understand
them. Also, changing the ABI is always tricky since you have to
provide backward and forwards compatibility with existing kernels
and with existing user space.

	Arnd
