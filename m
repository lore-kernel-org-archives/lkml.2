Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab2FKQyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:54:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58179 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab2FKQyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:54:50 -0400
Message-ID: <1339433759.4999.64.camel@lappy>
Subject: Re: net: nfc: BUG and panic in accept() on 3.5-rc2
From: Sasha Levin <levinsasha928@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, David Miller <davem@davemloft.net>,
        lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 11 Jun 2012 18:55:59 +0200
In-Reply-To: <1339426726.6001.2309.camel@edumazet-glaptop>
References: <1339423241.4999.53.camel@lappy>
	 <20120611144134.GX22557@sortiz-mobl>
	 <1339425693.6001.2268.camel@edumazet-glaptop>
	 <1339426241.4999.62.camel@lappy>
	 <1339426726.6001.2309.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 16:58 +0200, Eric Dumazet wrote:
> On Mon, 2012-06-11 at 16:50 +0200, Sasha Levin wrote:
> 
> > Eric, Is there something that documents at what state each of the
> > callbacks in the network subsystem can be called? Like a big flow chart
> > of some sorts?
> > 
> > I'm asking because I've looked at this as well before sending this mail,
> > and while the fix does look trivial, I wasn't sure whether it is really
> > the correct fix, or the problem is that this callback wasn't supposed be
> > called at all so something else is broken (we had such issue with
> > namespaces and unshare() not long ago).
> > 
> 
> I am not aware of such 'document'.
> 
> Things change, and only *good* reference is actual source code.
> 
> Now, take a look at sock_graft()/sock_orphan()/inet_release() ...

I see.

I grepped for release callbacks and the first few in the result (atm,
ax_25) did check for !sk, so I guess I'll just follow what I see in
other code in the future :)

