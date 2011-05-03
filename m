Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab1ECMxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 08:53:13 -0400
Received: from nm26-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.74]:20820 "HELO
	nm26-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751047Ab1ECMxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 08:53:10 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 584384.25265.bm@omp1009.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=pdw8Wj3wHanr1yBfbwonW3hhlK+CQlzJkFLyiGW48yxR+9cDRddKWsDky9fekPTv+X8xhPiOxw3Zkj8GMKZBST6VgVk/+wIhq1DH3iamP6Ijgxp/2oVv8FzJQJ/8j6rI9+UBGmPH2GpC23YZz0uk6QInNU1F/CMu02XMCEfiv7w=;
Message-ID: <484421.61252.qm@web161619.mail.bf1.yahoo.com>
X-YMail-OSG: 8dl5gyMVM1luPORcMb.X_jbdHMPfavT0S2vmILIbOYb.O33
 u6vQLjofN3sg1eqycI5G1qRh7M2nkmZJactUwxwFB882XnyNgvptm7GJ8TPB
 4pVRN7xLu_1gGzivi2mS9PwWEeDIHatdPqq6_n8F325fU_DVd7rPjA4..4Vp
 s1XZZPNHogohu.V.mkdlx1sCehfXs0KC3RhE4_lN.jFZTquS_V4YNHsBhqwX
 DbwSX3kZQ3l4K7t4PNq1jX9pojSu3NXsry1O2c6lqMu20lsWhHvcKdBH5G2g
 wKhZwq3JPIgupe4Rs1KBe3sTUFTJL4eDtMpBT5oJxnbCvKqqXqeI6Ir9Y503
 4qMutLzfKJd4J5r6l43giKt7EKY4W6iefD3FIkS9trTrb8w9M8GdRwA--
X-Mailer: YahooMailClassic/12.0.2 YahooMailWebService/0.8.110.299900
Date: Tue, 3 May 2011 05:53:09 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: 2.6.38: rt2800usb: driver is crashing the kernel
To: Justin Piszcz <jpiszcz@lucidpixels.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc: Roland Dreier <roland@kernel.org>, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4DBF574E.80309@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Just an update, this driver has been solid so far:
> > rt2870sta
> > 
> > With the Media Link 150 USB stick, not a single crash
> yet--
> > The rt2800usb driver is laggy and crashes the kernel
> (as of 2.6.38.x)--
> > Is there a possiblity to get rtl2870sta into the
> mainline?
> 
> Not a chance. As of 2.6.39, it is gone.
> 
> > It is the best wireless driver I've used for Linux
> with various usb wifi
> > adapters--
> 
> That driver was in staging because it does not use
> mac80211, which is an absolute requirement for a new
> mainline driver. Keeping things like rt2870sta that contain
> their own MAC layer just bloats the kernel and has code
> persist that no one really understands.
> 
> Please try the version of rt2800usb from compat-wireless
> with the latest firmware. If it still crashes the kernel,
> then post the bugs.
> 
> Larry

I agree to some extent that rt2870sta performs better compared to rt2800usb, as of now. However, significant strides have been made towards improving the rt2800usb as it pertains to these chips and I'm sure in due time, problems will be resolved.

The staging driver had to be removed in part because it collided with the rt2800usb, which in essence constitutes a race condition between the two drivers. When you plug your USB dongle, both of them load and both of them try to service your chip. The result isn't pretty. You have to manually blacklist one to enable the other to operate properly.

Now, if you're bent on using the staging driver, you can always grab it from Ralink's web site and ignore the future default rt2800usb.


Walter
