Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab0KVV2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 16:28:45 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:31890
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756434Ab0KVV2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 16:28:44 -0500
X-SpamScore: -12
X-BigFish: VS-12(zz1432N98dNzz1202hzzz2dh2a8h637h668h67dh685h66h)
X-Spam-TCS-SCL: 5:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw01.freescale.net;RD:de01egw01.freescale.net;EFVD:NLI
Message-ID: <4CEA9B00.1000804@freescale.com>
Date: Mon, 22 Nov 2010 10:32:00 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101101 Fedora/2.0.10-1.fc13 SeaMonkey/2.0.10
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
References: <20101118163321.GA2723@suse.de>	<4CE5562B.8080604@freescale.com>	<20101118165136.GA3103@suse.de>	<4CE55ACB.80207@freescale.com>	<20101118171856.GA4283@suse.de>	<4CE5647F.5000203@freescale.com>	<20101118175832.GA4931@suse.de>	<4CE58005.7040308@freescale.com>	<20101118200230.GA25715@suse.de>	<4CE58736.4090703@freescale.com>	<20101118201035.GA26287@suse.de>	<4CE58FE5.3010502@freescale.com> <20101118205647.677404ec@lxorguk.ukuu.org.uk>
In-Reply-To: <20101118205647.677404ec@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Nov 2010 16:33:09.0129 (UTC) FILETIME=[F2923F90:01CB8A62]
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> > Is there a way to do it in the driver itself?  Getting the boot loader to
>> > identify the specific byte channel for stdout isn't trivial.  It'd be nice if
>> > the driver could tell the tty layer, "BTW, this use this for the default console".

> You can - provide the required method in your console driver and it'll
> get used by /dev/console. Funnily enough a lot of other platform and
> consoles need that too.

Can you elaborate on that?  What is the "required method"?  My driver is mostly
working now, but I have to supply the command-line "console=ttyEHV73" in order
for the login prompt to show up.  Unfortunately, there's no way for the boot
loader to know that the primary byte channel for stdout is #73, so I need a way
for the driver to tell the kernel this.

Also, if I have a /dev/ttyEHV76 entry for a byte channel that's not the primary
stdout tty, is the following supposed to work:

	cat > /dev/ttyEHV76

That is, should I be able to use a TTY device as a normal character device,
where I can just write and read characters?

-- 
Timur Tabi
Linux kernel developer at Freescale

