Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab1C2MEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 08:04:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49873 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1C2MEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 08:04:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Date: Tue, 29 Mar 2011 14:04:38 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Waldemar.Rymarkiewicz@tieto.com, sameo@linux.intel.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        hthebaud@insidefr.com, matti.j.aaltonen@nokia.com
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <201103291305.02293.arnd@arndb.de> <20110329125931.21a69776@lxorguk.ukuu.org.uk>
In-Reply-To: <20110329125931.21a69776@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103291404.39023.arnd@arndb.de>
X-Provags-ID: V02:K0:n5WCYJlYjdMz39V1TodaMjAfqCODg33hSGvpYRAz2c6
 8aWZP+wMsP3N8YKg7zgFsREGNf7rRPpnP8TZoY+h1VreSPDfmi
 jg9roqSvWJ5EDX394lN+LDZxlpysieLMBq2zUrEp/OAYU9Dgt4
 eZsksap3M4p/xqJEZzBbPpIsEwJ5wzmzgCt9NELWBhOuehQzeD
 ZU1qVJT5jPSv0jAVNjIdg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 March 2011, Alan Cox wrote:
> > The difference between the two is where you keep the common
> > NFC logic:
> 
> I think I'd disagree on that
> > 
> > If you have a character device, it will be like a serial port
> > connecting to a modem. Any higher-level protocols live in the
> > user space and are limited to a single application then, which
> > is required to have appropriate priviledges to open the device.
> 
> A socket is just an API just as a file, you can put the stack in either
> place in either case.

Fair enough. Obviously the character device that we've been talking
about here does not include the stack, but that would be another option.

As you say, using a socket with a dumb interface is also possible,
but that sounds to me like a combination of all the disadvantages.

> > character device is its simplicity, so that would be preferred
> > if you only expect a very small set of possible applications
> > for this.
> 
> NFC is not particularly performance dependant so having a lot of the
> stack in a daemon isn't really going to hurt anything too much on a
> client embedded device/phone.
> 
> The bigger question is probably what it needs to look like the other end
> - ie the server side embedded devices doing transactions.

I was under the impression that NFC was peer-to-peer, so the driver
would already be handling both sides potentially.

	Arnd
