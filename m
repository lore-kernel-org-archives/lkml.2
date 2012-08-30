Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab2H3Lh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 07:37:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57408 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab2H3Lh2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 07:37:28 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: [PATCH 0/8] lp8727_charger: cleanup code
Thread-Topic: [PATCH 0/8] lp8727_charger: cleanup code
Thread-Index: Ac2Go69seS4U+KqpTO+wdMwOBAY4NA==
Date: Thu, 30 Aug 2012 11:37:16 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1C6B@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LP8727 driver should be patched for several reasons.

(a) Need to clean up _probe()/_remove()
(b) Not secure code when the platform data is NULL
(c) Interrupt handling
    Two threads are running for handling one IRQ.
    One is for the IRQ pin, the other is used for delayed processing.
    This is unusual and can be enhanced.
(d) Misuse of mutex code
(e) Lots of definitions should be fixed
(f) Others..

Bunch of code patches are as below.

[PATCH 1/8] lp8727_charger: use devm_kzalloc() rather than
 kzalloc()/kfree()
[PATCH 2/8] lp8727_charger: cleanup _probe() and _remove()
[PATCH 3/8] lp8727_charger: fix buggy code when the platform data is
 NULL
[PATCH 4/8] lp8727_charger: cleanup the interrupt handler code
[PATCH 5/8] lp8727_charger: move the mutex code
[PATCH 6/8] lp8727_charger: fix code for getting battery temperature
[PATCH 7/8] lp8727_charger: cleanup definitions
[PATCH 8/8] lp8727_charger: make cosmetic code

Best Regards,
Milo

