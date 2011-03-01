Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab1CAGyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 01:54:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44264 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab1CAGyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 01:54:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ZD8eB4CEzH0WWkPmAluSYhyMLNIWFNlgMAP/mEv6bBDus+yAnpww1mu1tz+xyoNyA7
         1mh5cCCIan7K23vU2PjattfD65NyXowlu3h3R/1gaU8RWJueSDiffeouycTx6jTzBng0
         KmkzDlE50zrvn7vJwKMT9IgATuUPVexGOPa7Y=
MIME-Version: 1.0
In-Reply-To: <20110228.201852.193726064.davem@davemloft.net>
References: <20110228165501.GC2515@tuxdriver.com>
	<AANLkTinj5szpStmA+fZ1xggdyTS+sd8Y9jXaYquDNEjs@mail.gmail.com>
	<AANLkTinFZu5AgfhO6PoA7C1NTGSfD8HH0KXq_o-mHEJF@mail.gmail.com>
	<20110228.201852.193726064.davem@davemloft.net>
Date: Tue, 1 Mar 2011 01:54:09 -0500
Message-ID: <AANLkTi=eDQh9Kvr9N_dTC5Cnbcfb+DbO-6tLxkZiEp9v@mail.gmail.com>
Subject: Re: txqueuelen has wrong units; should be time
From: Albert Cahalan <acahalan@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: johnwheffner@gmail.com, linville@tuxdriver.com, eric.dumazet@gmail.com,
        jussi.kivilinna@mbnet.fi, swmike@swm.pp.se,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 11:18 PM, David Miller <davem@davemloft.net> wrote:
> From: Albert Cahalan <acahalan@gmail.com>
> Date: Mon, 28 Feb 2011 23:11:13 -0500
>
>> It sounds like you need a callback or similar, so that TCP can be
>> informed later that the drop has occurred.
>
> By that point we could have already sent an entire RTT's worth
> of data, or more.
>
> It needs to be synchronous, otherwise performance suffers.

Ouch. OTOH, the current situation: performance suffers.

In case it makes you feel any better, consider two cases
where synchronous feedback is already impossible.
One is when you're routing packets that merely pass through.
The other is when some other box is doing that to you.
Either way, packets go bye-bye and nobody tells TCP.
