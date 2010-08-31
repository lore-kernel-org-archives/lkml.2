Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab0HaNNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 09:13:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60293 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338Ab0HaNNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 09:13:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=g3myXYw/ND0rHRBRHzbX1KAZwEoigm8UCqeJV4d8Ijcq8bqogKPanSmWUiLNNi/rQw
         /By9ItopHH2BxTyGpP6dCJmn1CodHUVjH+o6tHduaxs2yOGM6i6vi7Bwl/ExDuNpw2lj
         qLboiyjqGjcMDLdSLndm6MFJyYcVHOWOjDlAs=
Subject: Re: [PATCH net-next-2.6] net/ipv4: push IP options to CB in
 ip_fragment
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Bandan Das <bandan.das@stratus.com>, David Miller <davem@davemloft.net>,
        NetDev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Patrick McHardy <kaber@trash.net>
In-Reply-To: <20100831123641.GA31017@gondor.apana.org.au>
References: <20100830200917.GA10754@stratus.com>
	 <1283204118.2405.32.camel@edumazet-laptop>
	 <20100830232147.GB10754@stratus.com>
	 <1283232031.2405.38.camel@edumazet-laptop>
	 <20100831082444.GB29281@gondor.apana.org.au>
	 <1283246271.2550.35.camel@edumazet-laptop>
	 <20100831123641.GA31017@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 15:13:29 +0200
Message-ID: <1283260409.2550.87.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 31 août 2010 à 20:36 +0800, Herbert Xu a écrit :
> On Tue, Aug 31, 2010 at 11:17:51AM +0200, Eric Dumazet wrote:
> >
> > Once again, the IP stack -> bridge -> IP stack flow bites us,
> > because bridge likes to dirty IPCB.
> 
> OK, so we're talking about a locally transmitted packet, with
> IP options leaving the IP stack, entering bridging, and then
> reentering the IP stack?
> 
> In that case the packet should no longer be treated as an IP
> packet when it enters the bridge.  So if it did have options
> and we want to support that in bridging then we need to parse
> IP options there as my comment suggested.

Bandan did not provide a full stack trace,
but I believe the problem was :

br_nf_dev_queue_xmit() -> ip_fragment -> icmp_send() ->
ip_options_echo() : crash, because ip_options_echo take bridge CB as
IPCB data.

http://www.spinics.net/lists/netdev/msg139370.html




