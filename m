Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab0IGGdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 02:33:49 -0400
Received: from n2-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.155]:36417 "HELO
	n2-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751066Ab0IGGdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 02:33:45 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 356684.11233.bm@omp131.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=H1uACB3aT4LEwdPq6ENfOkshojYuZWhn/vaBb8DIkVvlM0UmOccrEuOlk+ZHCGS/XEq826m6oMMykHnPYMcaBvIffV5uWvOk8MQJSzKO8YEqm3UqUIErf664JHTGFd74WSpXpEN+1s+NfW+xGsmQcSbGC2tp9/20/cngqomWD3s=;
Message-ID: <159882.19856.qm@web180315.mail.gq1.yahoo.com>
X-YMail-OSG: huhCBmwVM1lEHdNs1WHvmsQ8lg.hlIzdx7CASakkE1fmd25
 4E2JJcvImuPKF4upVz9OlX__FUX1UuEwuBLaKZJKXZzVm1BU641oPbaxKlvK
 fMGAtsgC6askJtBJJIVEqakGsoX7CogQ6a7FHn5lmgivQgf8Ek.BzScMRaAc
 hIpSWvFLjChMf6VgEwSPBAQk_eRkzwmPlsgi4MG0XWnFNqoqcPXsWPtNB.BX
 AF6v0Ypg2rLRhBIa0Wl8rVM4xN8eHqcYfIxQqcVR05RzSjnUNS0AOet0y7oS
 1zQ1.TcvnbAqQ_qexeYOZMCWIp3l5D1un2BoaiVEQumorXV41b8l_9Pa16dh
 pdfJK0pQ2vyItMVTK9lBQpYnaPjscdq5yyhM-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Mon, 6 Sep 2010 23:33:43 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] pio: add arch specific gpio_is_valid() function
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bn@niasdigital.com, avictor.za@gmail.com
In-Reply-To: <4C85A71F.3010402@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Mon, 9/6/10, Ryan Mallon <ryan@bluewatersys.com> wrote:


> How about this approach instead?

Still don't like it, sorry.  gpio_is_valid()
is not intended as a fine-grained call, there is
a call which is fine grained; use that instead.

> ----
> On some architectures gpio numbering does not start from zero.

But on all of them, zero is a valid GPIO number.
It could get dynamically allocated someday...

 Allow for
> correct behaviour of gpio_is_valid

I'd say it's already correct ... what's not
correct is expecting to validate the *active* set
of GPIOs (some dynamically allocated) through
that, instead of one of the GPIO setup calls
like gpio_request, which have explicit guarantees
of reporting errors for GPIO numbers which are
not usable on the target board.


 on values below the
> first gpio by
> adding the architecture overrideable ARCH_FIRST_GPIO.

What are you (?) doing that it even matters
to a driver  which GPIOs are built into the SOC
versus external?  Caring about arch-specific
stuff at this level is a big thought-bug...

And  I'd ask why you're ignoring or bypassing
the error reporting from gpio_request() ...

That is, just what are you doing that makes
you want gpio_is_valid() to include error checks
you are supposed to get via gpio_request as part
of GPIO configuration?

