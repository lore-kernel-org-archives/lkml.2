Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab0IKTIG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 15:08:06 -0400
Received: from n5.bullet.mail.gq1.yahoo.com ([67.195.9.85]:44200 "HELO
	n5.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752036Ab0IKTIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 15:08:02 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 300533.20442.bm@omp126.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=RuPr6bb674K1O8luiGxUz+stIxb7E3VZAybzYJZJfsy9WhAstuSEBPeC8c9T5bL8OQYMFIYQqO93eXJasKP624rXACDeqIiMqFyGHz0vfgF7LdzxIvQxm9WEqvTYtiEpDG0hNquWjDqpcNBTFahi1NsEoM0UGGDFGj57KLZQUpM=;
Message-ID: <704982.67431.qm@web180312.mail.gq1.yahoo.com>
X-YMail-OSG: YoK8ZGIVM1miB9q6DRobQnN9KR.emPfoxxlYtuzWMplyr_p
 dK97Gwl604Dbbbm.PXjNuKD3Vev9FzqrZvheQfnRleBAda0OVK3Y.ux8cjZc
 1qKZsvfCIYMhU8oFTsLxJE1648r7Z_uBSdQIgwjSvt9wz2I0mxJvGw6wfm8G
 kUOdg1nWillOvBrY8RMb6eGAN5piGCFyb4kb_GKVSlGi_FOHODgq2zZZAaEt
 DST5Nl6.9CIdCLcN5R_qdWfZhkH_Ll3Ia0Nodom0rSqkzWfDrv3zNVVD64Bl
 12iCe2OACFgxkt9mF7O14svQAYBbSffVRpxFgvmAsJ1zUoJKwCkUDWxk2ALO
 PeNG4To3ffMIl8wQ9W22jDPVyPt_2lZa34MpBnSz1hRY4ytNSfxKx.v.kQQ-
 -
X-Mailer: YahooMailClassic/11.4.7 YahooMailWebService/0.8.105.279950
Date: Sat, 11 Sep 2010 12:07:59 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v2] usbnet: do not count empty skbs as errors in rx_process()
To: Ondrej Zary <linux@rainbow-software.org>
Cc: netdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <201009102336.00722.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 9/10/10, Ondrej Zary <linux@rainbow-software.org> wrote:

> From: Ondrej Zary <linux@rainbow-software.org>
> Subject: [PATCH v2] usbnet: do not count empty skbs as errors in rx_process()

NAK to this backwards-incompatible change.

At this point there's no way to know how many
drivers it breaks ... I do know that counting
such SKBs as errors has previously turned up
link-level errors, and thus led to bugfixes.


> If rx_fixup() returns an empty skb
> (because it consumed all data inside),

The canonical reason the SKB would be empty is
because after rx_fixup() removed all header and
trailer data, there was no packet body left.
Which is likely a link error, and has been
worth accounting as such in the past (turned up
bugs on TX or RX sides).

> do not count it as error.
> 
> This is needed for cx82310_eth.

I'd far rather see that driver fixed, than see
the core usbnet framework broken to avoid such
fixes to a very new driver ...


