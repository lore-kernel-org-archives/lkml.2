Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab0CXOyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 10:54:09 -0400
Received: from web94904.mail.in2.yahoo.com ([203.104.17.148]:39651 "HELO
	web94904.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932077Ab0CXOyG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 10:54:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=BxWAyX5lg1hh/9qzAeBGP7qRqrZXePoypF0eSZNp53lwVpGjzXFl7oEvAirocKkKtZEVZ7xkJbTa3hqTXqXdKrsNfcWQAD4ts4mgwFwT7+Rs9JVr8cI32+jbJvzTA+NW+Cyez9wBkgRJtSsWmlF71qkbyGawZ+ALjrVxPIWjlug=;
Message-ID: <359814.2971.qm@web94904.mail.in2.yahoo.com>
X-YMail-OSG: RHUBfQYVM1kB4H3BzsjZaFAlBGbHIc7fbqJ6xqu1emH0uU0
 3Uj3KB2K3xrDuNNgeJPDWhravn_uz1UmZFyRDkUrNBY_VB8RQQRjcSbEaEv7
 qH1Gldu_8ZKZ4xZdPahSuL4HQIlnfeMa1RxzC.qXlzoqATdSdLaDBVng.HUO
 CV2NDVpwfcDNvSXibC5qFCHl53YCr5ZyCVmrgyEHh9_I_Xmu6fRnkFuxrgg7
 S7LSoa_lU3q6qxm7RLc4fT08QfwgDq5x6U6osKGiLiekCG2UFG98iqBOW6Mt
 1j3M8u3dNy4hhFegP7aITLDg-
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Wed, 24 Mar 2010 20:24:01 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
To: Greg KH <gregkh@suse.de>, Marcel Holtmann <marcel@holtmann.org>
Cc: PavanSavoy <pavan_savoy@ti.com>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1269417860.11714.112.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 24/3/10, Marcel Holtmann <marcel@holtmann.org> wrote:

> From: Marcel Holtmann <marcel@holtmann.org>
> Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
> To: "Greg KH" <gregkh@suse.de>
> Cc: "Savoy, Pavan" <pavan_savoy@ti.com>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> Date: Wednesday, 24 March, 2010, 1:34 PM
> Hi Greg,
> 
> > > The source for this problem, was that I could not
> install line
> > > discipline from kernel space.  i.e make
> N_TI_SHARED line discipline
> > > the current ldisc from kernel space itself.
> > 
> > Are you sure?  I thought the bluetooth core did
> this already.  Have you
> > looked at how that works?
> 
> I didn't have time to look at it at all so far. However I
> think this
> should just go via a proper review process. And it might
> need some
> architecture review first. It is clearly not a candidate
> for staging
> since it is not really self-contained.
> 
> Regards
> 
> Marcel
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


Marcel, Greg,

I wanted to somehow put this in staging because then it would probably have a thorough architectural review process.
Some details about this driver - 

1. This driver will be used by Bluetooth-BlueZ/FM-V4L2 and GPS (probably character device driver) using the EXPORTED symbols (-register/_unregister).

2. Much like the hciattach daemon which maintains N_HCI bluetooth line discipline, this driver will also have a User-Space  N_TI_WL Init manager (UIM) maintaining the Line discipline.

3. Because of the UIM should know when to install/uninstall line discipline, the /sys entry is created a root called UIM (a new kobject) and UIM daemon would write it's PID to it.

4. As Alan suggested, If I make it self-contained by pushing number of line disciplines to a slightly larger number, then would it be OK ?



      Your Mail works best with the New Yahoo Optimized IE8. Get it NOW! http://downloads.yahoo.com/in/internetexplorer/
