Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab1CQNiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 09:38:19 -0400
Received: from ebb05.tieto.com ([131.207.168.36]:55717 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989Ab1CQNiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 09:38:17 -0400
X-AuditID: 83cfa824-b7b21ae000000a96-39-4d820ec7033d
From: <Waldemar.Rymarkiewicz@tieto.com>
To: <arnd@arndb.de>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 17 Mar 2011 15:38:07 +0200
Subject: RE: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Topic: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Thread-Index: AcvkpFgpIJuUQa7hQLS0UGw2gwrUUgAAEAIg
Message-ID: <99B09243E1A5DA4898CDD8B70011144810830AB18B@EXMB04.eu.tieto.com>
References: <1299766808-2535-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
 <201103101720.53782.arnd@arndb.de>
 <99B09243E1A5DA4898CDD8B70011144810830AB119@EXMB04.eu.tieto.com>
 <201103171407.58164.arnd@arndb.de>
In-Reply-To: <201103171407.58164.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, 

>An application can open the device, and then do a 
>pthread_create() or a fork(). In either case, you have two 
>concurrent threads that have access to the file pointer and 
>can read from it concurrently, which is inherently racy 
>regarding which of the processes gets the data.

In that case I would relay on the application to synchronise the access.

>This is not very different from opening the file descriptor in 
>multiple processes, which you prevent using your logic.

but in the case when two independent applications try to open my device I can't let the second to access. They obviously won't synch the access.

>You can of course argue that you try your best to prevent the 
>race. Traditionally, e.g. on serial ports and the like, we 
>don't do this but instead rely on user space synchronizing the 
>access. What you have to make sure of course is that multiple 
>threads calling read on the same file can never bring the 
>kernel driver into an invalid state.

I assume, if an application shares the file pointer deliberately it have to sync the access. In other cases, the driver needs to secure it.

Waldek