Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab0J3RqP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 13:46:15 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:36834 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab0J3RqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 13:46:13 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 30 Oct 2010 10:45:37 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@davide-lnx1
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Davide Libenzi <davidel@xmailserver.org>,
        Alban Crequy <alban.crequy@collabora.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pauli Nieminen <pauli.nieminen@collabora.co.uk>,
        Rainer Weikusat <rweikusat@mssgmbh.com>
Subject: Re: [PATCH] af_unix: optimize unix_dgram_poll()
In-Reply-To: <1288432420.2680.933.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1010301042040.12598@davide-lnx1>
References: <20101029191857.5f789d56@chocolatine.cbg.collabora.co.uk>  <1288380431.2680.3.camel@edumazet-laptop>  <alpine.DEB.2.00.1010291306390.8517@davide-lnx1>  <alpine.DEB.2.00.1010291339180.8517@davide-lnx1> <1288432420.2680.933.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1701732935-1288460744=:12598"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1701732935-1288460744=:12598
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sat, 30 Oct 2010, Eric Dumazet wrote:

> Le vendredi 29 octobre 2010 à 13:46 -0700, Davide Libenzi a écrit :
> 
> > Also, why not using the existing wait->key instead of adding a poll2()?
> 
> Indeed, if wait is not null, we have in wait->key the interest of
> poller. If a particular poll() function is expensive, it can test these
> bits.
> 
> Thanks !
> 
> Note: I chose the 'goto skip_write' to make this patch really obvious.

Plain agreement on th patch, and I understand the indent overflow 
concerns, but why not ...

	/*
	 * No write status requested, avoid expensive OUT tests.
	 */
	if (wait && !(wait->key & (POLLWRBAND | POLLWRNORM | POLLOUT)))
		return mask

The write-test code is the last one we do anyway.


- Davide


--8323329-1701732935-1288460744=:12598--
