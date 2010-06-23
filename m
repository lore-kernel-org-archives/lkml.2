Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab0FWNk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 09:40:26 -0400
Received: from n9.bullet.mail.ac4.yahoo.com ([76.13.13.237]:24839 "HELO
	n9.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751794Ab0FWNkY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 09:40:24 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 425039.25513.bm@omp125.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Wyq8C2iaDMdUxqf3TxVqtmkCCRiy4EAaBa/uzb2I+2eiKYlsDwgQ8erWx/OEkB8UGTUo8NUpgdJrhxDcB/0n3Czrgg/LhY1zw1kQJN5VFgNKNFCcfCWqgpRoqRMLSHNMPMAJnSYYoCkI6AI/RR2HMeTeKxGBnpEERCv5GJGoQT0=;
Message-ID: <294115.59939.qm@web180308.mail.gq1.yahoo.com>
X-YMail-OSG: CCsgNqYVM1mdcqVTEvXmkB9hNYBA1MMTHsLoBc525qiXue6
 Kkm_g8VGZZAdEDDSXarb5FUu_Lg8G_18Oeqlsq0YnLr5tdtzb6sZusQhGSI7
 ZZuaBK1WgErVi293HG69xNhvk_C4UB_lCw5S29GW4LYkp1c8HFxdPR2z_ycc
 AAz4X25po0HHawjQsi3sFpkcs8J2e2xPw90.TwX315PNRHHzHQble_dICl3T
 UgUZJyiP.tXCCMvByDjDZG0JsF29wECTejnbsUpzC6BUJVNPfVtUXen3FwGG
 _ziLapUzKvXNSoc6YEccAc.zi4qoRbE1RHNXOVgZNKCnzlYtS3Q--
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.104.274457
Date: Wed, 23 Jun 2010 06:39:09 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: gpiolib and sleeping gpios
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       "gregkh@suse.de" <gregkh@suse.de>,
       =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
In-Reply-To: <alpine.DEB.2.00.1006231601310.7850@wnav-qrfxgbc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Wed, 6/23/10, Jani Nikula <ext-jani.1.nikula@nokia.com> wrote:

> -    WARN_ON(extra_checks &&
> chip->can_sleep);
> +    might_sleep_if(chip->can_sleep);

 That looks like the right track.  For
those cases the "extra_checks" should
not be optional ... thanks.

- Dave


