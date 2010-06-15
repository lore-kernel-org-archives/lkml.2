Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab0FOKn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 06:43:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52852 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab0FOKn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 06:43:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Date: Tue, 15 Jun 2010 12:42:27 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Andrew" <andrew.chih.howe.khor@intel.com>,
       "Intel OTC" <joel.clark@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>
References: <4C0CE88C.9050708@dsn.okisemi.com> <201006141450.53572.arnd@arndb.de> <000401cb0c53$91a9e300$66f8800a@maildom.okisemi.com>
In-Reply-To: <000401cb0c53$91a9e300$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006151242.28097.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18CbKfpnUuz+sjVz84OB3f60Ky1W8FA1VH9dIo
 CRjF3WOwKlRfUwA+4BbNQDZQZwMtmpb1L2FXJTf14IVUEX0I/y
 nhsfXZuQXkXCBqC146f+w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 June 2010, Masayuki Ohtake wrote:
> >This should not be necessary. Just use CONFIG_PCH_CAN_PCLK_50MHZ directly
> >in the code instead of the extra PCH_CAN_PCLK_50MHZ macro.
> 
> I have a question. I show the above reason.
> In case CAN is integrated as MODULE, macro name is CONFIG_PCH_CAN_PCLK_50MHZ_MODULE.
> On the other hand, integrated as built-in, CONFIG_PCH_CAN_PCLK_50MHZ.
> To prevent PHUB source code from integrated as MODULE or BUILT-IN,
> we re-define macro name in Makefile.
> 
> If use CONFIG_PCH_CAN_PCLK_50MHZ directly in the source code,
> in case buit-in, behavior is not correct.
> But in case module, behavior is not correct.

I don't understand the problem, because you have the definition

config PCH_CAN_PCLK_50MHZ
       bool "CAN PCLK 50MHz"
       depends on PCH_PHUB

which is 'bool', not 'tristate', so it can never be a module.
If you are referring to a dependency on the CAN code that is
not part of this patch, you can express this as

config PCH_CAN_PCLK_50MHZ
       bool "CAN PCLK 50MHz"
       depends on PCH_PHUB || CAN != "n"

This will leave CONFIG_PCH_CAN_PCLK_50MHZ as bool and let it only
get enabled if CONFIG_CAN is either "y" or "m".
Does that answer your question?

	Arnd
