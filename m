Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab1ARSEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 13:04:35 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:58899 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab1ARSEe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 13:04:34 -0500
X-Greylist: delayed 635 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jan 2011 13:04:33 EST
Date: Tue, 18 Jan 2011 17:51:43 +0000
From: Alban Crequy <alban.crequy@collabora.co.uk>
To: Eric Dumazet <eric.dumazet@gmail.com>,
        Ian Molton <ian.molton@collabora.co.uk>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        ebiederm@xmission.com, xemul@openvz.org, davidel@xmailserver.org
Subject: Re: [PATCH] af_unix: implement socket filter
Message-ID: <20110118175143.3a164669@chocolatine.cbg.collabora.co.uk>
In-Reply-To: <1295371361.3290.15.camel@edumazet-laptop>
References: <1295368755-20931-1-git-send-email-ian.molton@collabora.co.uk>
	<1295371361.3290.15.camel@edumazet-laptop>
Organization: Collabora
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.23.90; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Tue, 18 Jan 2011 18:22:41 +0100,
Eric Dumazet <eric.dumazet@gmail.com> a écrit :

> Le mardi 18 janvier 2011 à 16:39 +0000, Ian Molton a écrit :
> > From: Alban Crequy <alban.crequy@collabora.co.uk>
> > 
> > Linux Socket Filters can already be successfully attached and
> > detached on unix sockets with setsockopt(sockfd, SOL_SOCKET,
> > SO_{ATTACH,DETACH}_FILTER, ....). See:
> > Documentation/networking/filter.txt
> > 
> > But the filter was never used in the unix socket code so it did not
> > work. This patch uses sk_filter() to filter buffers before delivery.
> > 
> > This short program demonstrates the problem on SOCK_DGRAM.

By the way, the patch implements socket filters on SOCK_DGRAM and
SOCK_SEQPACKET but not SOCK_STREAM. Socket filters does not make sense
to me when there is no packet boundaries. But if there is a need for
it, the code for SOCK_STREAM could be added easily.

> Any idea on performance cost adding sk_filter() call ?

Ian will write a performance test and repost the patch with some stats.
I don't know about the performance cost.

> Hmm, looking at it, I have no idea why sk_filter() needs to block BH.

I don't know neither.

> I'll send a patch to relax this requirement.

Thanks for your review!

Alban
