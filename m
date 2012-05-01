Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752Ab2EAAol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:44:41 -0400
Received: from uhura.skim.hs-owl.de ([193.174.118.81]:52774 "EHLO
	uhura.skim.hs-owl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281Ab2EAAo2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:44:28 -0400
Message-ID: <4F9F31E0.5020308@googlemail.com>
Date: Tue, 1 May 2012 02:44:16 +0200
From: Jan Seiffert <kaffeemonster@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120327 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: David Miller <davem@davemloft.net>, <eric.dumazet@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION][PATCH V4 3/3] bpf jit: Let the powerpc jit handle
 negative offsets
References: <1335760199.20866.33.camel@pasglop>  <4F9E188E.80503@googlemail.com> <1335763568.20866.37.camel@pasglop>  <20120430.134140.1738751315208907289.davem@davemloft.net>  <1335822926.20866.47.camel@pasglop> <1335823049.20866.48.camel@pasglop>  <4F9F12ED.1090009@googlemail.com> <1335831987.20866.93.camel@pasglop>
In-Reply-To: <1335831987.20866.93.camel@pasglop>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Skim-SendBy: exchange.hs-owl.de on Tue, 01 May 2012 02:44:22 +0200
X-SA-Exim-Connect-IP: 193.174.118.178
X-SA-Exim-Mail-From: kaffeemonster@googlemail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt schrieb:
> On Tue, 2012-05-01 at 00:32 +0200, Jan Seiffert wrote:
> 
>> *shudder*
>> Link to another lib for only one function because....
>>
>> http://cvsweb.netbsd.org/bsdweb.cgi/src/sys/net/bpf.h?rev=1.59&content-type=text/x-cvsweb-markup&only_with_tag=MAIN
>> The "Original" says it's an u_int.
>>
>> But i guess it is unfixable without breaking something, except with ugly code.
>> Should the padding at least be made explicit in the in-kernel struct?
>> Did anyone ever tested the 32bit on 64bit compat code (different padding)?
> 
> Haven't tested no. A quick google pointed to 2 web pages telling people
> to do the wrong thing and 4 broken programs out there, interestingly in
> different ways :-) (somebody's doing a reinterpret_cast of one struct
> into another, somebody does his/her own local redefinition of the
> struct ... using a ulong !, etc....)
> 

Ouch!

> I don't see a good way to sort that out other than introducing a new
> kernel-side structure, change the sockopt number, and support the old
> one as backward binary compat, but that's gross.
> 

But a sane way forward?

BTW, has anyone checked the new syscall filter code for these ... misfortunes?
I mean before the ABI is set in stone...

> Cheers,
> Ben.
> 
> 
> 

Greetings
	Jan

-- 
😉 
