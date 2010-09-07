Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab0IGXpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 19:45:00 -0400
Received: from n9.bullet.mail.ac4.yahoo.com ([76.13.13.237]:33449 "HELO
	n9.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755991Ab0IGXo6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 19:44:58 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 222102.25273.bm@omp205.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=d19/MwvxqJIaZBQy4vkAXZP2/ITVcGkMhD7WzT351uGXTD5hC5xsoB0kq8kjbQKV67AC94q5CSDV4qIrp/Hc35X6llofPugLY2Go8Y2Jpj/U88qZlQFIk6KuH/aHf3NhaHkNHsBgNvfOqFmm7vJQrY11duv4Stk7fgCQaguTf5s=;
Message-ID: <616992.75276.qm@web180302.mail.gq1.yahoo.com>
X-YMail-OSG: KY8VU.MVM1kCHQwpbYaw.nHEghbHW8CKn3w4knkuvcGQhaF
 pYfJ6MykYgcYEl5F8nlb8rPBTd_X6ozCMvH3x00rK3B0oIipTaACZoZQ2nx8
 v0tWKmj6b4oPX2SvcW6B2Xfr70WEU61SFgFARrT4amxBIAVq56d31U8OsnOR
 Oim8fM7N1y.yYdObA0zXza2uUg77WO1.76piags4o4baX6hE59nhhnyEYqFQ
 CBW.rZ_u0ldDwe7Tlj8sbHaiEeljEUPXvMj_RDQOW.AyUp3tPvvog4OVIR21
 yeoptUHpjMhmbz_XDpCEg9dVWCq3czgpNsHF_TrlcTbJKnOntiGapaZaz_So
 KP0vhlCkP5pVmDP0wOJ2KdAFKf6IR
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Tue, 7 Sep 2010 16:44:55 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] pio: add arch specific gpio_is_valid() function
To: Ryan Mallon <ryan@bluewatersys.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "avictor.za@gmail.com" <avictor.za@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        bn@niasdigital.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100907222230.4a3594be@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Tue, 9/7/10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > 
> >      device->output_pin = -EINVAL;
> 
> gpio numbers are unsigned in the rest of the API

Minor goof; should have been "int" everywhere,
as implied by the references to negative numbers
in the docs... negatives not used internally, but
preserved for external use (as above).


> 
> It's unfortunate that 0 was used for a GPIO

Intentional:  board schematics and chip docs can
easily match up to Linux this way.  What would be
unfortunate is needing to map hardware docs into
software ones all the time -- error prone.

When the API is used correctly, it's not an issue.

