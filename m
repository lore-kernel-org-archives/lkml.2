Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab0JYXTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:19:06 -0400
Received: from adsl-99-30-218-25.dsl.aus2tx.sbcglobal.net ([99.30.218.25]:53214
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479Ab0JYXTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:19:04 -0400
Message-ID: <4CC6104B.7040204@microgate.com>
Date: Mon, 25 Oct 2010 18:18:35 -0500
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] n_hdlc fix read and write locking
References: <1288030959.19909.28.camel@x2.microgate.com> <201010252231.06794.arnd@arndb.de>
In-Reply-To: <201010252231.06794.arnd@arndb.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2010 3:31 PM, Arnd Bergmann wrote:

> Would it be possible to express the same using
> wait_event_interruptible()?

Yes if I embed an assignment in the event expression:

rc = wait_event_interruptible(&wait, (buf = get_buf()));
if (!rc)
	process_buf(buf);

Is that considered acceptable?

-- 
Paul Fulghum
MicroGate Systems, Ltd.
=Customer Driven, by Design=
(800)444-1982
(512)345-7791 (Direct)
(512)343-9046 (Fax)
Central Time Zone (GMT -5h)
www.microgate.com
