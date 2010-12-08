Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab0LHBDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:03:52 -0500
Received: from kroah.org ([198.145.64.141]:33813 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609Ab0LHBDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:49 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:47 2010
Message-Id: <20101208005746.994011134@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [256/289] ARM: 6456/1: Fix for building DEBUG with sa11xx_base.c as a module.
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>

commit b9f515e3e3861abbaa093359f7c6f31283695228 upstream.

This patch fixes a compilation issue when compiling PCMCIA SA1100
support as a module with PCMCIA_DEBUG enabled. The symbol
soc_pcmcia_debug was not beeing exported.
ARM: pcmcia: Fix for building DEBUG with sa11xx_base.c as a module.

This patch fixes a compilation issue when compiling PCMCIA SA1100
support as a module with PCMCIA_DEBUG enabled. The symbol
soc_pcmcia_debug was not beeing exported.

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pcmcia/soc_common.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pcmcia/soc_common.c
+++ b/drivers/pcmcia/soc_common.c
@@ -65,6 +65,7 @@ void soc_pcmcia_debug(struct soc_pcmcia_
 		va_end(args);
 	}
 }
+EXPORT_SYMBOL(soc_pcmcia_debug);
 
 #endif
 


