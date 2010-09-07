Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab0IGCX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 22:23:29 -0400
Received: from n4-vm0.bullet.mail.gq1.yahoo.com ([67.195.9.7]:27296 "HELO
	n4-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751530Ab0IGCXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 22:23:23 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 473498.29288.bm@omp202.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=TrSx/Rl9UABWFobDwNtHy9hzhlFHmaNr8ji5J7fFyecmPmKojQxVY31QmelAz52Uotqo4GKk4QpfRcsVVwvdxU5f1g7w0+yUTmLDyFKW/fNcFofQ7gH/zgt4EOFdBwmNBEFNw5LGMu5zBLsyrqMrmQ47AQK9Sxrr/HrnCJdoK1Q=;
Message-ID: <280328.53116.qm@web180311.mail.gq1.yahoo.com>
X-YMail-OSG: 0nuqRrwVM1m4BgvvcJtKIQqAa18HFhZUydacfW.tI15ifFy
 i5X_fdQ4QMREkRE1MPe7FLPzrO.EYghUEKGNLilqhULiNnOzQ8aq5GW8JvxI
 KdUxmuWzoB9xgFUu5.MRwzUQ0H8IH.Vhhk1h6_AIbxJ6astUXOCFzi.qwWDS
 BZWo1JWMBtI8008ZrSFZ65Ixz.2tT2sR.zu.4x1NARPH_Oe4ltdIe.DfE47A
 cEb8G9GHor8yUwkKzYXT0QaYIDbs51YqbqC7AP5vUcrktMVFBF02vl0056B3
 9sTKUibHJgZjC.e73pg--
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Mon, 6 Sep 2010 19:23:22 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] pio: add arch specific gpio_is_valid() function
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bn@niasdigital.com, ryan@bluewatersys.com, avictor.za@gmail.com
In-Reply-To: <20100903164158.GH17702@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still not liking or accepting this proposed
change to the GPIO framework.

For the AT91 case (where integers 0..N are
IRQs, but N..max are GPIOs)

A simpler solution is just to use a bit in
the integer to indicate IRQ vs GPIO.  Like
maybe the sign bit.. which is never set on
valid GPIO numbers, but platforms could let
be set on IRQs.

