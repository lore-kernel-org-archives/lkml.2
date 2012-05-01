Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab2EAA0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:26:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:47057 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757250Ab2EAA0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:26:35 -0400
Message-ID: <1335831987.20866.93.camel@pasglop>
Subject: Re: [REGRESSION][PATCH V4 3/3] bpf jit: Let the powerpc jit handle
 negative offsets
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jan Seiffert <kaffeemonster@googlemail.com>
Cc: David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 01 May 2012 10:26:27 +1000
In-Reply-To: <4F9F12ED.1090009@googlemail.com>
References: <1335760199.20866.33.camel@pasglop>
	 <4F9E188E.80503@googlemail.com> <1335763568.20866.37.camel@pasglop>
	 <20120430.134140.1738751315208907289.davem@davemloft.net>
	 <1335822926.20866.47.camel@pasglop> <1335823049.20866.48.camel@pasglop>
	 <4F9F12ED.1090009@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-01 at 00:32 +0200, Jan Seiffert wrote:

> *shudder*
> Link to another lib for only one function because....
> 
> http://cvsweb.netbsd.org/bsdweb.cgi/src/sys/net/bpf.h?rev=1.59&content-type=text/x-cvsweb-markup&only_with_tag=MAIN
> The "Original" says it's an u_int.
> 
> But i guess it is unfixable without breaking something, except with ugly code.
> Should the padding at least be made explicit in the in-kernel struct?
> Did anyone ever tested the 32bit on 64bit compat code (different padding)?

Haven't tested no. A quick google pointed to 2 web pages telling people
to do the wrong thing and 4 broken programs out there, interestingly in
different ways :-) (somebody's doing a reinterpret_cast of one struct
into another, somebody does his/her own local redefinition of the
struct ... using a ulong !, etc....)

I don't see a good way to sort that out other than introducing a new
kernel-side structure, change the sockopt number, and support the old
one as backward binary compat, but that's gross.

Cheers,
Ben.


