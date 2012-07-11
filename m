Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab2GKKpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 06:45:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54923 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab2GKKpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 06:45:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: Re: [PATCH] misc/pch_phub: Enable UART clock setting by module parameter
Date: Wed, 11 Jul 2012 10:45:02 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
References: <1342000670-1005-1-git-send-email-tomoya.rohm@gmail.com>
In-Reply-To: <1342000670-1005-1-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207111045.03275.arnd@arndb.de>
X-Provags-ID: V02:K0:PuyBiWd1s/VhqTjjwct2elE9ochYTj60Io6JIb4YBf1
 0BjRbfG8MhmcxmfRtsLSqyUSUgteoRcPakz8bXJdaSx1OPso7t
 tLKZpfEo+3FCmKtYDEa5Uuq1AfuiwfnriqIyZNZmNjvdf3SXZ7
 YvU1iF8deBUPqaNjc3ogyXSEg2KvoG++TZjAB0gUoE8tgpNU3G
 +vaITNbiqUPjH0XVd9fun3/8bcJfk3tpao7UnKkoquOHSriRAG
 4gQXdx5UJJfjxPH4a892PO2bFVwnY0PjTHrTrJwaxglNLFojHO
 aiWoJZoRezFkhaIC8bQ4kiCdj1qKSbvsdJbBvcplq9ScY2HOh2
 TkTMi+X7HhoH5nYq8Cd0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 July 2012, Tomoya MORINAGA wrote:
> Currently, when a user wants to change UART clock,
> needs to modify this source code by hand.
> This patch enables changing UART clock by specifying UART clock
> as module parameter.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>

This looks like a rather nonscalable solution if you get to systems
with lots of clocks.

Given that you are doing it for the uart clock, shouldn't that be
set from the uart driver using an ioctl like other serial ports do?

What would be the use case for an end user to override the module
parameter? Is it about platform specific settings or policy?

	Arnd
