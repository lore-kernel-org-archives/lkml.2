Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490Ab1CCQsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 11:48:06 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46322 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758221Ab1CCQsE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 11:48:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XSp2yd8Xaxn1xTltZsdtX0K3QfdF//TXIHjSfn24paJeLW8WyEhUrx9tbRCpkNYZMM
         t0pHDKrE/BgsAlNURu94+EJH1QPVJHJ35rY2ZEaAFlPsLLxF1Ev5069OJc4hm/BBG4QZ
         ETllV/8GYJYBwAJI41hZmx+ih8GqNxynbkeZM=
MIME-Version: 1.0
In-Reply-To: <20110120145728.453ccacd.akpm@linux-foundation.org>
References: <bug-26922-10286@https.bugzilla.kernel.org/>
	<20110119132659.3e815450.akpm@linux-foundation.org>
	<4D38B721.9090906@gmail.com>
	<20110120145728.453ccacd.akpm@linux-foundation.org>
Date: Fri, 4 Mar 2011 01:48:02 +0900
Message-ID: <AANLkTimSoXKig_ZZTBS2dcnKSAVLwTKOFtwdKw+BsE5p@mail.gmail.com>
Subject: Re: [PATCH][Bug 26922]USB: yurex: recognize GeneralKeys wireless
 presenter as generic HID (Re: New: 2.6.37 breaks USB wireless presenter HID device)
From: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/21 Andrew Morton <akpm@linux-foundation.org>:
> On Fri, 21 Jan 2011 07:28:49 +0900
> You hit the jackpot.  The patch was wordwrapped, space-stuffed and
> tab-replaced!
>
> Here's my attempt to reconstruct it:

Sorry for broken patch, and thanks for your repair.
The patch was confirmed to successfully fix the regression in recognition
of Wireless Presenter by the original bug reporter.

https://bugzilla.kernel.org/show_bug.cgi?id=26922

> From: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
>
> Unfortunately, the device seems to have the same Vendor ID and Product ID
> as YUREX leg-shakes sensors, and the commit 6bc235a2e2 ("USB: add driver
> for Meywa-Denki & Kayac YUREX") added the ID to hid_ignore_list.
>
> I believe that we can distinguish YUREX and the Wireless Presenter by
> device type.  The patch below makes the driver ignore only YUREX
> (bInterfaceProtocol==0), and recognize Wireless Presenter
> (bInterfaceProtocol is keyboard or mouse) as generic HID.  (I don't have
> the Wireless Presenter, so not yet ested.)
