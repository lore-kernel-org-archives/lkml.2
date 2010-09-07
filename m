Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab0IGRcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 13:32:41 -0400
Received: from n2-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.155]:49056 "HELO
	n2-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757881Ab0IGRcj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 13:32:39 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 506419.14608.bm@omp126.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=zeOD8nR4i8Mka7UJn2UspsVVLkKIV7VErWwBeDUmJTiBdTxzv5QbJk0Hut7XfHZgKWjn7w53dnw8ASh8wGY8WXlTGpewkJojK1b3JZtLJazWlqwdS8gPWdw87jgzTzNTVIot/G1Sf8Pvg4XvPRi+Gnnz55OJMrj/siw6XG2MG+0=;
Message-ID: <255134.38265.qm@web180307.mail.gq1.yahoo.com>
X-YMail-OSG: Yg0GbxAVM1lXNBKkLqFthsItuqAqNjxALiimziXrIvW1Dzy
 287KDuuTgX24JCCTr7BEisPZdK3EluWR2XPZs3OWx5Z1Tx0GQ4ed7GBHzPQM
 9hQ1dh527i.kBl5Ol80dzOFb5R204edwm16EMJ9KutlA3mXetVlAb27UgpPr
 y4hFqn7cvLyKDKD.6RbO.0WxK1O56OYw25CrubNXoIgaoS8esbHEP0wTZbT7
 np4i9HE.KI2JnPHH1QQ58Z5QtCStb5apaKJ_JwZEfIbfquILbCRct1ueAAl5
 yeLZN87R5hcNKrxz8teu3NjCYmRjaSuqdcryfj9pFsq_SNapLeEq0nQ--
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Tue, 7 Sep 2010 10:32:38 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] pio: add arch specific gpio_is_valid() function
To: Ben Nizette <bn@niasdigital.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        avictor.za@gmail.com
In-Reply-To: <0D5B5291-80B9-4576-8DC7-8F33CFF2A803@niasdigital.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> gpio_is_valid determines whether a gpio /can/ be attached to acontroller,

Or more simply:  whether its numeric prameter is
a valid argument to gpio_request() and friends.


 gpio_request determines whether that gpio
> currently /is/
> attached to a controller.

Of course, "controller" is out of sight of folk
just using GPIOs.  Otherwise, that's a fair take
on one set of gpio_request() error reports.


  Part of the confusion seems
> to come at least
> in part from the overlooking of facility for dynamically added gpio numbers.

Maybe, but I think most of it came from folk who
expected "valid" to mean (your terminology) the
GPIO number is now connected to a controller.
(Otherwise $SUBJECT would be meaningless since
there'd be no arch-specific issue.
> 
> Fix the documentation to clarify these points.

Patch is forthcoming.

