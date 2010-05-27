Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab0E0MyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 08:54:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56339 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab0E0MyC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 08:54:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cqLN5MLSXHGBdIEQiUmK8yGN5SpaBZoahma8aw5SbnUgjDDgnreM4JlHvI+SooECHo
         KLLe0MMYlHGwO4nch1WRnV0E+j7erQcgKoHCpHO8XcOMO56mqi0c4npcIPwYzJ1DnR8e
         IwItflreYcfselu/+qH+qsbtYlmwVvMRx0PfY=
MIME-Version: 1.0
In-Reply-To: <4BFE3BB8.1030503@kernel.org>
References: <AANLkTikBrXROMvNKrhgxQ1jVh6aOsx3nIrNXTznXInV1@mail.gmail.com> 
	<20100526151152.28deaa6c@linux.intel.com> <AANLkTikuzGazcBpSvqU73UAAIvcTgxTBsmWTr9bNCSjB@mail.gmail.com> 
	<4BFE1695.5000206@kernel.org> <AANLkTik2MyWWogREK1DpXKeYrutr7skHQB7kzeg6DYvq@mail.gmail.com> 
	<4BFE3BB8.1030503@kernel.org>
From: Frank Pan <frankpzh@gmail.com>
Date: Thu, 27 May 2010 20:53:37 +0800
Message-ID: <AANLkTim023Yz2RyOM58E9Ywnq1py6xDVWDJGmvjCOpFH@mail.gmail.com>
Subject: Re: [PATCH 0/2] Enlarge the storage of chars in virtual terminal
To: Tejun Heo <tj@kernel.org>
Cc: Alan Cox <alan@linux.intel.com>,
       Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Daniel Mack <daniel@caiaq.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, Jochen Hein <jochen@jochen.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Dave Airlie <airlied@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

> I'm not an export on the issue but if I'm not mistaken it gets more
> complex than that.  It took quite some time to solve the problem
> properly even on full desktop envs.
Maybe the issue on full desktop envs comes from different frameworks?
(gtk, qt, etc...)
On tty, it's just a char device. It may have difficulties, but unknown before
totally implement it. AFAIK, it's easier than desktop envs.

> And other than yourself, how many would such users be?  What's your
> reason for not using X other than "console looks cooler"?  Even if you
> have some valid reason to not use X and absolutely have to have
> multilingual support, what prevents you from using fb based terminals
> like jfbterm which already works with input and all without
> introducing any i18n related complexities into kernel?  To me, it
> seems like low activiy on jfbterm seems to show the low demand for
> such feature.  So, just use X.
Not everyone likes X. Forcing one who think X is a huge thing using X
even when checking emails is... too bad. People may have their own
choice, I think.

A brief view of jfbterm tells me it's a good thing, and the source code
tells me that it does almost the same thing in vt: esc char handling,
terminal configuration, etc. Plus, pcf parsing and encoding identification.
That's why I think we are re-inventing the wheel. Kernel do esc char
handling, kernel do terminal configuration, kernel do utf-8 decoding,
kernel do dynamic font changing. Why don't we just enlarge the glyphs
a font can have, so all the things go well?

Thanks for reply.

-- 
Frank Pan

Computer Science and Technology
Tsinghua University
