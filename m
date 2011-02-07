Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab1BGG3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 01:29:46 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57845 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab1BGG3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 01:29:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=w25im5Ed6WxW7bylHy2p5Mw/VkJdlUnUoFHBdrUkRzyWZsyWYL+CXkglxkm0Q2aB5/
         SF2L4iv8uFFF/GLQ1zpGJ5wBK0T3ZbUKDwr+3Nn/e911heco4YkF9xxgucoAqjhIxSag
         6tfKQcahtElEQpiJFmv9C4+mCWgr+sMo9QjWg=
MIME-Version: 1.0
In-Reply-To: <20110206.202824.260090071.davem@davemloft.net>
References: <20110131130826.GC16804@shadowen.org>
	<AANLkTik-ywwtNg2AxAXtsKYJviDp=1zCZ-43JXp9i3g6@mail.gmail.com>
	<20110206.202824.260090071.davem@davemloft.net>
Date: Mon, 7 Feb 2011 17:29:43 +1100
Message-ID: <AANLkTik8hg5G2FYDCoRgh72v-_euGWKix9Fxm89UdXie@mail.gmail.com>
Subject: Re: x25: possible skb leak on bad facilities
From: Andrew Hendry <andrew.hendry@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: apw@canonical.com, john@calva.com, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tim.gardner@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The issue is a bit more complex than Andy's patch, I think I have a full fix.
Burning it in on test system now, if thats OK ill post patch in a few hours.


On Mon, Feb 7, 2011 at 3:28 PM, David Miller <davem@davemloft.net> wrote:
> From: Andrew Hendry <andrew.hendry@gmail.com>
> Date: Tue, 1 Feb 2011 22:55:13 +1100
>
>> There are two callers, when I was crashing it I don't remember it
>> using the backlog path.
>> x25_process_rx_frame is called from both x25_backlog_rcv and also
>> x25_receive_data (via x25_lapb_receive_frame)
>>
>> But reviewing that second path now it looks like it will also leak, -1
>> would make it skip the kfree_skb there as well.
>> So patch looks good to me, when I have some time I'll run it through
>> the environment I had setup originally to confirm.
>
> Andrew, have you had a chance to do this yet?
>
