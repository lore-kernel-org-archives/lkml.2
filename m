Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab2FKO64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:58:56 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46106 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab2FKO6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:58:51 -0400
Subject: Re: net: nfc: BUG and panic in accept() on 3.5-rc2
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, David Miller <davem@davemloft.net>,
        lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1339426241.4999.62.camel@lappy>
References: <1339423241.4999.53.camel@lappy>
	 <20120611144134.GX22557@sortiz-mobl>
	 <1339425693.6001.2268.camel@edumazet-glaptop>
	 <1339426241.4999.62.camel@lappy>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jun 2012 16:58:46 +0200
Message-ID: <1339426726.6001.2309.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 16:50 +0200, Sasha Levin wrote:

> Eric, Is there something that documents at what state each of the
> callbacks in the network subsystem can be called? Like a big flow chart
> of some sorts?
> 
> I'm asking because I've looked at this as well before sending this mail,
> and while the fix does look trivial, I wasn't sure whether it is really
> the correct fix, or the problem is that this callback wasn't supposed be
> called at all so something else is broken (we had such issue with
> namespaces and unshare() not long ago).
> 

I am not aware of such 'document'.

Things change, and only *good* reference is actual source code.

Now, take a look at sock_graft()/sock_orphan()/inet_release() ...



