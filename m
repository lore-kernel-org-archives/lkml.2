Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab1KWViV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 16:38:21 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:10478 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab1KWViT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 16:38:19 -0500
Message-ID: <4ECD67C7.3010702@hp.com>
Date: Wed, 23 Nov 2011 13:38:15 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: gdfuego@gmail.com, richard.weinberger@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Finding a hidden bound TCP socket
References: <CALmbKGV0g2nfNAghF5dGrt=TCyrms6RznOL8jSkg+gkgyfekLg@mail.gmail.com> <CAFLxGvynabpEcX2RwiLxatjOEzizj95jAVY6E4D9ymDpn8s9UA@mail.gmail.com> <CALmbKGVUuZs+wigpkr0WPfn2pYP=tQh5-MsYWeRxbug=HskVQQ@mail.gmail.com> <20111123.160143.58902472755124590.davem@davemloft.net>
In-Reply-To: <20111123.160143.58902472755124590.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 01:01 PM, David Miller wrote:
> From: "G. D. Fuego"<gdfuego@gmail.com>
> Date: Wed, 23 Nov 2011 15:27:33 -0500
>
>> Any comments?  The behavior seems broken.  At the very least its very
>> inconsistent with other Unixes.
>
> Until the socket has a full final tuple it is bound to, there is no
> reason to list it.
>
> No UNIX lists a socket which is partially bound and hasn't either
> performed a listen() or a connect().

Well....  I took the .c file mentioned previously, and compiled it on a 
Solaris 10 8/11 instance.  The 25-odd sockets it created *were* listed 
in the output of netstat -an -- local address as *.<portnum> remote 
address as *.* and a state of "BOUND."

A FreeBSD  (rev 8 IIRC) netstat -an seems to display them in a state of 
"CLOSED."  I didn't check HP-UX 11i v3 or AIX 6.

rick jones
