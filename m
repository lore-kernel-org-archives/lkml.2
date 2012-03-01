Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2CAR7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 12:59:08 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63113 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab2CAR7G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 12:59:06 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eric.dumazet@gmail.com designates 10.50.140.2 as permitted sender) smtp.mail=eric.dumazet@gmail.com; dkim=pass header.i=eric.dumazet@gmail.com
MIME-Version: 1.0
In-Reply-To: <CABBYNZKN+7z4Sr9DBniokez6Jru02LxPgWdGNcVeYECse+AzEQ@mail.gmail.com>
References: <AE90C24D6B3A694183C094C60CF0A2F6026B6E86@saturn3.aculab.com>
	<1330606237.27405.5.camel@megeve>
	<1330606775.2465.56.camel@edumazet-laptop>
	<4F4F7FFB.6010608@collabora.co.uk>
	<CABBYNZKN+7z4Sr9DBniokez6Jru02LxPgWdGNcVeYECse+AzEQ@mail.gmail.com>
Date: Thu, 1 Mar 2012 09:59:05 -0800
Message-ID: <CAL4WiiqjvA7iN8nydOx9tp8gOg1M_EDWKU5N+V5JFa90JbS8Ug@mail.gmail.com>
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to AF_UNIX
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rodrigo Moya <rodrigo.moya@collabora.co.uk>,
        David Laight <David.Laight@aculab.com>,
        David Miller <davem@davemloft.net>, javier@collabora.co.uk,
        lennart@poettering.net, kay.sievers@vrfy.org,
        alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk,
        sjoerd.simons@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 1 mars 2012 08:02, Luiz Augusto von Dentz <luiz.dentz@gmail.com> a écrit :
>
> Contrary to someones believes I don't think AF_INET is that fast (e.g.
> http://scottmoonen.com/2008/04/05/a-performance-comparison-of-af_unix-with-loopback-on-linux/)
>

Oh you mention a recent zork it seems ;)

Are we speaking of performance problems, apart from scheduler problems
for D-Bus (each message wakeing all receivers, all receivers read and
drop message but the target) ?

I am actually one of the few people working to improve performance on
both AF_INET and AF_UNIX parts. Just take a look at recent commits.

Right now you can send/receive millions of udp messages per second on
your linux machine, if you figured out how to avoid process scheduler
costs. If D-Bus wants more, I highly suggest using shared memory
instead of passing messages.
