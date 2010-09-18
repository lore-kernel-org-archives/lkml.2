Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab0IRDQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 23:16:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38129
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754703Ab0IRDQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 23:16:45 -0400
Date: Fri, 17 Sep 2010 20:17:04 -0700 (PDT)
Message-Id: <20100917.201704.181464273.davem@davemloft.net>
To: james@albanarts.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, airlied@redhat.com,
        akpm@linux-foundation.org, marcin.slusarz@gmail.com,
        FlorianSchandinat@gmx.de, vda.linux@googlemail.com,
        jbarnes@virtuousgeek.org, jsimmons@infradead.org
Subject: Re: [PATCH] fbmem: Fix fb_read, fb_write unaligned accesses.
From: David Miller <davem@davemloft.net>
In-Reply-To: <201009180123.48303.james@albanarts.com>
References: <201009180123.48303.james@albanarts.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Hogan <james@albanarts.com>
Date: Sat, 18 Sep 2010 01:23:47 +0100

> Apologies for corrupted patch. I'll try again.
> Comments? I'd also appreciate if somebody familiar with sbus on sparc
> could check this patch is sane since I know virtually nothing about sbus
> and am not in a position to compile for sparc, let alone test on it:
> 
> fb_{read,write} access the framebuffer using lots of fb_{read,write}l's
> but don't check that the file position is aligned which can cause
> problems on some architectures which do not support unaligned accesses.
> 
> Since the operations are essentially memcpy_{from,to}io, new
> fb_memcpy_{from,to}fb macros have been defined and these are used
> instead.
> 
> For Sparc, fb_{read,write} macros use sbus_{read,write}, so this defines
> new sbus_memcpy_{from,to}io functions the same as memcpy_{from,to}io but
> using sbus_{read,write}b instead of {read,write}b.
> 
> Signed-off-by: James Hogan <james@albanarts.com>

Compiles cleanly on sparc and looks correct to me:

Acked-by: David S. Miller <davem@davemloft.net>
