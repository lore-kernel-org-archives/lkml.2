Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab1JLEbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 00:31:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42594 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1JLEbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 00:31:15 -0400
Message-ID: <1318393869.3686.26.camel@edumazet-laptop>
Subject: Re: [PATCH v3] net-netlink: Add a new attribute to expose TOS
 values via netlink
From: Eric Dumazet <eric.dumazet@gmail.com>
To: MuraliRaja Muniraju <muralira@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Wed, 12 Oct 2011 06:31:09 +0200
In-Reply-To: <CAP3iWTQXHwzw-qUYVfT--uNv4pNZnu0ROJnF7B1VLeZBbrfdqw@mail.gmail.com>
References: <20111010145206.6f7e9ee2@nehalam.linuxnetplumber.net>
	 <1318382887-31824-1-git-send-email-muralira@google.com>
	 <1318387734.3686.2.camel@edumazet-laptop>
	 <CAP3iWTQXHwzw-qUYVfT--uNv4pNZnu0ROJnF7B1VLeZBbrfdqw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 11 octobre 2011 à 21:16 -0700, MuraliRaja Muniraju a écrit :
> Eric,
>      I think it would be useful to expose the values this way.
>      I shall make the changes to add TCLASS for ipv6 in the description.
> 
>      Regarding the TIME_WAIT state, I think it would be better of not
> exposing the values because there would hardly be anything to transmit
> during this time.
> 

My remark had nothing to do with your patch actually :

We dont store TOS/TCLASS on TIME_WAIT sockets, so you cannot report
value in inet_diag.

But we do send packets on behalf of TIME_WAIT sockets ;)

Think about ACK messages. They probably are sent with a 0 TOS/TCLASS
field... I am not sure its a problem or not.



