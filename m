Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab2D3Wcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 18:32:31 -0400
Received: from uhura.skim.hs-owl.de ([193.174.118.81]:36699 "EHLO
	uhura.skim.hs-owl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795Ab2D3Wc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 18:32:29 -0400
Message-ID: <4F9F12ED.1090009@googlemail.com>
Date: Tue, 1 May 2012 00:32:13 +0200
From: Jan Seiffert <kaffeemonster@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120327 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: David Miller <davem@davemloft.net>, <eric.dumazet@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION][PATCH V4 3/3] bpf jit: Let the powerpc jit handle
 negative offsets
References: <1335760199.20866.33.camel@pasglop>  <4F9E188E.80503@googlemail.com> <1335763568.20866.37.camel@pasglop>  <20120430.134140.1738751315208907289.davem@davemloft.net>  <1335822926.20866.47.camel@pasglop> <1335823049.20866.48.camel@pasglop>
In-Reply-To: <1335823049.20866.48.camel@pasglop>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Skim-SendBy: exchange.hs-owl.de on Tue, 01 May 2012 00:32:23 +0200
X-SA-Exim-Connect-IP: 193.174.118.178
X-SA-Exim-Mail-From: kaffeemonster@googlemail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt schrieb:
> On Tue, 2012-05-01 at 07:55 +1000, Benjamin Herrenschmidt wrote:
>> On Mon, 2012-04-30 at 13:41 -0400, David Miller wrote:
>>> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>>> Date: Mon, 30 Apr 2012 15:26:08 +1000
>>>
>>>> David, what's the right way to fix that ?
>>>
>>> There is no doubt that sock_fprog is the correct datastructure to use.
>>
>> Ok, so the right fix is to email anybody who posted code using struct
>> bpf_program to fix their code ? :-)
> 
> Actually, the right fix is for anybody using pcap-bpf.h to not
> use SO_ATTACH_FILTER directly but to use pcap_setfilter() which
> handles the compatibility.
> 

*shudder*
Link to another lib for only one function because....

http://cvsweb.netbsd.org/bsdweb.cgi/src/sys/net/bpf.h?rev=1.59&content-type=text/x-cvsweb-markup&only_with_tag=MAIN
The "Original" says it's an u_int.

But i guess it is unfixable without breaking something, except with ugly code.
Should the padding at least be made explicit in the in-kernel struct?
Did anyone ever tested the 32bit on 64bit compat code (different padding)?

> I'll start spamming web sites who tell people to do the wrong thing.
> 
> Cheers,
> Ben.
> 

Greetings
	Jan

-- 
A UDP packet walks into a
