Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab1D2RTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 13:19:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34722 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894Ab1D2RTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:19:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CTZ85OL12at3Xhy1LgV5kS5lIAiCqxLscSbI7agsRqU8UM3weGd0BkCKN4Y57Q+57l
         v+4RGCdKFuwvvOWoMgW4nArP7AAjvw3lAlT6GwvXMJai5DXwvSG940MoIANLM6SSE3Ss
         Pn1U7FELutLBjwpIDT5t6SsDbwW7nYNn7jn0M=
Subject: Re: linux-next: Tree for April 29 (bpf_jit)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>, David Miller <davem@davemloft.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110429092632.26ff1e53.randy.dunlap@oracle.com>
References: <20110429131940.4f4c938f.sfr@canb.auug.org.au>
	 <20110429092632.26ff1e53.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 19:19:18 +0200
Message-ID: <1304097558.2686.6.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 29 avril 2011 à 09:26 -0700, Randy Dunlap a écrit :
> On Fri, 29 Apr 2011 13:19:40 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20110428:
> 
> 
> when CONFIG_MODULES is not enabled:
> 
> bpf_jit_comp.c:(.text+0x43cc2): undefined reference to `module_free'
> (.text+0x4521a): undefined reference to `module_alloc'
> (.text+0x453af): undefined reference to `module_free'
> 
> 

Oh well, I guess we can add one 'depends on MODULES' like we do for
KPROBES (it also uses module_alloc())

Not sure many people build a !CONFIG_MODULES kernel these days...

Thanks Randy !

[PATCH net-next-2.6] bpf: depends on MODULES

module_alloc() and module_free() are available only if CONFIG_MODULES=y

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/Kconfig |    1 +
 1 files changed, 1 insertion(+)

diff --git a/net/Kconfig b/net/Kconfig
index 745fb02..878151c 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -238,6 +238,7 @@ config HAVE_BPF_JIT
 config BPF_JIT
 	bool "enable BPF Just In Time compiler"
 	depends on HAVE_BPF_JIT
+	depends on MODULES
 	---help---
 	  Berkeley Packet Filter filtering capabilities are normally handled
 	  by an interpreter. This option allows kernel to generate a native


