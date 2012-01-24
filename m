Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab2AXJsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 04:48:25 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59092 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754772Ab2AXJsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 04:48:23 -0500
Message-ID: <1327398498.7231.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [patch v2, kernel version 3.2.1] Source mode for macvlan
 interface
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?UTF-8?Q?=C5=A0tefan?= Gula <steweg@ynet.sk>
Cc: Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 24 Jan 2012 10:48:18 +0100
In-Reply-To: <CAGsizzLD=0t_J5m=CdZn8+1j6ZD_Nmz352kydDKDqQKDK5nxSw@mail.gmail.com>
References: <29378065.3471327360294412.JavaMail.root@5-MeO-DMT.ynet.sk>
	 <1327362739.2587.15.camel@edumazet-laptop>
	 <CAGsizzLD=0t_J5m=CdZn8+1j6ZD_Nmz352kydDKDqQKDK5nxSw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 24 janvier 2012 à 10:07 +0100, Štefan Gula a écrit :
> 2012/1/24 Eric Dumazet <eric.dumazet@gmail.com>:

> > How many 'sources' are expected per port ?
> >
> > Above a certain (small) threshold, macvlan_fill_info() will 'overflow'
> > skb capacity and return an error.
> >
> > Take a look at macvlan_get_size() ?
> There should be no defined limits on how many MAC addresses you can
> put under one macvlan interface - it should be fully dynamic. You are
> right about the function, but I have a difficulty with fixing that. It
> is no problem to calculate the space needed to dump all mac-address,
> but I tried to check how many times is macvlan_get_size called and it
> is called only once per macvlan interface initialization, which is
> obviously wrong in my case as I need that number to be changed each
> time before fill_info is called. I tried to find and example how to
> managed that from other drivers, but I was unsuccessful. Do you have
> any idea?

Take a look at commit c7ac8679bec9
(rtnetlink: Compute and store minimum ifinfo dump size)

and maybe extend it if necessary ?


