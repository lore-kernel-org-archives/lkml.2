Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab1CKH6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 02:58:39 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:65051 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab1CKH6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 02:58:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: Re: [PATCH 1/2] tty: serial: Fix build on architecture that does not have ioport
Date: Fri, 11 Mar 2011 08:58:29 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.5.1; x86_64; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
References: <1299822897-7047-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
In-Reply-To: <1299822897-7047-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103110858.29140.arnd@arndb.de>
X-Provags-ID: V02:K0:7jLblq/C9qZvH1SLSr1U3gxTtQuwXs0Qa8sChmny2zR
 0FjXd0tkkwbNfWfiNLcIb1SMJnBGG1H0h7Enm7rMtvwV6yTtBC
 M9D97nCMSp/QOvN1J7BhKjWiYi3A21bP/cfioRsD+knd5zi9m5
 r9luWr7vGFdk02KEkVQ7qUeJbvetm0fy6dMnTxuVv22hXHO5WK
 OHDCfsGJKXNA540tW1yEA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 March 2011 06:54:56 Nobuhiro Iwamatsu wrote:
> Some CPU's do not have ioport. Therefore, these do not have inX/outX.
> Because they define CONFIG_NO_IOPORT, These CPU's use this and do not
> use inX/outX.
> 
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>

I like this patch, I had played with something similar before
but never got it to the state where I was happy with submitting
it. I'd really like to get us to the point where platforms without
PCI support do don't need to define inb/outb and can still
use all other drivers.

There are two small improvements that I would like to suggest
to this patch:

* use #ifdef CONFIG_SERIAL_8250_HUB6 to configure out hub6 support.
  It's already disabled on most systems, so we can save a bit
  binary code without making the driver uglier.

* Introduce a new CONFIG_SERIAL_8250_IOPORT symbol and make
  the normal io_serial_* code depend on that. It can be a silent
  Kconfig symbol that automatically gets selected in the appropriate
  cases. I find this clearer than the double negation in "not no ioport".
  The code that is used in both HUB6 and regular cases can be under
  this symbol.

	Arnd
