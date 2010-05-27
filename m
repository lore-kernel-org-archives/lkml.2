Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab0E0O4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:56:17 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63097 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab0E0O4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:56:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KkgAll7yHnkZcdEoUhFuJi5VeTsY/H3tDPRtVs91DyiyhUXU2st8veYosAg/GMdSxA
         aUxM6HOrS0LPRlA4htrf4++LCJgABsY+41lEChBL6UTh5oj3awQW5yGGf5dBwO6xgj2W
         7WhkdzY0qbfsja3ubbXZsDlHXKsTI7Y22ZNK0=
Date: Thu, 27 May 2010 23:01:22 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] gconfig: fix build failure on fedora 13
Message-ID: <20100527150122.GC3600@hack>
References: <1274952149.2210.12.camel@castor.rsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274952149.2210.12.camel@castor.rsk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 10:22:28AM +0100, Richard Kennedy wrote:
>Making gconfig fails on fedora 13 as the linker cannot resolve dlsym.
>    
>Adding libdl to the link command fixes this.
>    
>make shows this error :-
>    /usr/bin/ld: scripts/kconfig/kconfig_load.o: undefined reference to symbol 'dlsym@@GLIBC_2.2.5'
>    /usr/bin/ld: note: 'dlsym@@GLIBC_2.2.5' is defined in DSO /lib64/libdl.so.2 so try adding it to the linker command line
>    /lib64/libdl.so.2: could not read symbols: Invalid operation
>
>tested on x86_64 fedora 13.
>
>Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

Looks good to me.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.


>---
>patch against 2.6.34, built & tested on x86_64. 
>
>regards
>Richard
>
>diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
>index 186c466..9842611 100644
>--- a/scripts/kconfig/Makefile
>+++ b/scripts/kconfig/Makefile
>@@ -208,7 +208,7 @@ HOSTCFLAGS_zconf.tab.o	:= -I$(src)
> HOSTLOADLIBES_qconf	= $(KC_QT_LIBS) -ldl
> HOSTCXXFLAGS_qconf.o	= $(KC_QT_CFLAGS) -D LKC_DIRECT_LINK
> 
>-HOSTLOADLIBES_gconf	= `pkg-config --libs gtk+-2.0 gmodule-2.0 libglade-2.0`
>+HOSTLOADLIBES_gconf	= `pkg-config --libs gtk+-2.0 gmodule-2.0 libglade-2.0` -ldl
> HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
>                           -D LKC_DIRECT_LINK
> 
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
