Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab0GKDLW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 23:11:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:32934 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab0GKDLV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 23:11:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wcLn2ekxaCxg3nPIkGnzLCp6Jf/96tGn3GIYNYhZwa1z63UA98dxH+yAilaNo7+6Vc
         Z1WKLSDpiaxK77ivFyXO+2rKAcZP1y9ButLCo4ZA+qHVF/gyytov4Jk2Mv/XSpjjXv6s
         Keqvu3/A0W80/SYQb9RmyEKkFWvWaz7JlLfTQ=
MIME-Version: 1.0
In-Reply-To: <20100710.123011.260095467.davem@davemloft.net>
References: <1278695580.2696.55.camel@edumazet-laptop>
	<AANLkTil39xHOhcdAo4h_jWtx_UuYdFHGdQVAdwPMd7QJ@mail.gmail.com>
	<1278742649.2538.17.camel@edumazet-laptop>
	<20100710.123011.260095467.davem@davemloft.net>
Date: Sun, 11 Jul 2010 00:11:20 -0300
Message-ID: <AANLkTilQbM8F27a5SLZLMzndLYfz-eRhzyxP18KCFz2K@mail.gmail.com>
Subject: Re: [PATCH] tproxy: nf_tproxy_assign_sock() can handle tw sockets
From: Felipe W Damasio <felipewd@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, kaber@trash.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mr. Miller,

2010/7/10 David Miller <davem@davemloft.net>:
> It could be corruption from elsewhere.  Those last four hex
> digits (0x5d415d41) are "]A]A" in ascii, but that could just
> be coincidence.

What do you mean "from elsewhere"? You mean elsewhere on the network code?

Since the function that had the problem was tcp_recvmsg and we're
talking about a squid process, we're either talking about a typical
webserver-objet response, or about about an incorrect/faulty http
request from the user.

Like I told Mr. Dumazet, since on the squid logs I got a:

2010/07/08 14:51:10| clientTryParseRequest: FD 6088
(187.16.240.122:2035) Invalid Request

Only a second before the bug entry on syslog, I suppose that this
invalid request caused the problem (more like a guess, really).

If you think there's a way I can help reproduce/trigger and fix this
bug, please let me know, since the production machine is down until I
can ensure my bosses that this particular crash won't happen again.

Thanks,

Felipe Damasio
