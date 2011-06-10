Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab1FJH7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 03:59:44 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19455 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab1FJH7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 03:59:42 -0400
Date: Fri, 10 Jun 2011 09:51:22 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: David Miller <davem@davemloft.net>
cc: viro@ZenIV.linux.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Sparc: Remove trigraph in die_if_kernel()
 message.
In-Reply-To: <20110609.160611.1243367560228886911.davem@davemloft.net>
Message-ID: <alpine.LNX.2.00.1106100947010.19998@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106071627260.8844@swampdragon.chaosbits.net> <20110609.155943.162785602513776337.davem@davemloft.net> <20110609230322.GY11521@ZenIV.linux.org.uk> <20110609.160611.1243367560228886911.davem@davemloft.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1561661386-1307692113=:19998"
Content-ID: <alpine.LNX.2.00.1106100948510.19998@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1561661386-1307692113=:19998
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LNX.2.00.1106100948511.19998@swampdragon.chaosbits.net>

On Thu, 9 Jun 2011, David Miller wrote:

> From: Al Viro <viro@ZenIV.linux.org.uk>
> Date: Fri, 10 Jun 2011 00:03:22 +0100
> 
> > On Thu, Jun 09, 2011 at 03:59:43PM -0700, David Miller wrote:
> >> > If I'm not mistaken, that "??!" will be taken as a trigraph for "|" by the 
> >> > preprocessor, so the final string will end up either as
> >> >   "Penguin instruction from Penguin mode|?!"
> > 
> > Not without -trigraphs, which is not on by default...
> 
> Oh, in that case I'll rever this.
> 

Well, my gcc warns about it. It seems that -Wtrigraphs is enabled by 
default:

[jj@dragon src]$ gcc --version
gcc (GCC) 4.6.0 20110603 (prerelease)
Copyright (C) 2011 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO                                                                                    
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR 
PURPOSE.

[jj@dragon src]$ cat test.c
#include <stdio.h>

int main()
{
  printf("Penguin instruction from Penguin mode??!?!");
  return 0;
}
[jj@dragon src]$ gcc test.c
test.c: In function ¡main¢:
test.c:5:48: warning: trigraph ??! ignored, use -trigraphs to enable [-Wtrigraphs]


Which was why I wrote in my original submission mail :

"... which I assume is not what we want, or as the correct string but with 
a warning about an ignored trigraph which I assume we don't want either."

So either we get the wrong string (if someone enables -trigraphs) or we 
get a warning (at least with newer gcc's). Which is why I felt the patch 
made sense as a way to avoid both unfortunate results.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
--8323328-1561661386-1307692113=:19998--
