Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab1ECMwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 08:52:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61257 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1ECMwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 08:52:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/2] watchdog: add support for MOXA V2100 watchdog driver
Date: Tue, 3 May 2011 14:51:56 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Wolfram Sang <w.sang@pengutronix.de>, jimmy.chen@moxa.com,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        wim@iguana.be
References: <20110503103704.69aba5b2@lxorguk.ukuu.org.uk> <20110503105735.GB2497@pengutronix.de> <20110503121510.5bba70c5@lxorguk.ukuu.org.uk>
In-Reply-To: <20110503121510.5bba70c5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105031451.56911.arnd@arndb.de>
X-Provags-ID: V02:K0:HrdCY9g/otYrXTaKHrp8rjN0b94E+wK0iYRK8BJARON
 QkcCRBUFv2mEWn9PON+uVTCpPNpfSSpBK3urGFBXPsJeOo1VsF
 toOFVVdeBfwgHk5eFmXEPe9/vaIERoGqCINP9eutiKPT93qAZb
 XRVC2M8U61vtLFdgdQpMv40v93lNqi1lXWgQAb6dwBjOKXOXSf
 +Tw9wgTpNhE2C/3CRW2PA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 May 2011, Alan Cox wrote:
> > Hmm, code in a header? Can't this go into the main source? Hmm, at least
> > it87_wdt.c has something very similar. Maybe it can even be shared? What
> > about locking BTW?
> 
> The spinlock handles it if you look at the caller points, because you
> have to own the super I/O and select it each time.

I suppose the functions should at least be 'static inline' so they avoid
polluting the global namespace.

> Ultimately it wants to be using request_muxed_* but that isn't in any of
> the mainstream code yet so can be done in the future when the mux patches
> go in.

Another thing that might be nice here is to have one module that probes
the superio-port and then registers a platform device that other drivers
can can bind to. Right now, you have to load the module manually and
then check if it's there, something we no longer do for most devices.

	Arnd
