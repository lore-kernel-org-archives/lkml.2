Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761978Ab0J2UpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:45:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38577 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761845Ab0J2UpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:45:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AE7wzteRZOUgFIfHmfmdpU/8+2k674ptdhlk69pXU9YgGzyuGyD2/iQMeT/CQE28GO
         5LzYdxZrw90x+0vE9uI1egG2d8sPXcmN7zq9YEbvuvim5DworP/23N+YBN6kuvEvVOfA
         RvXxLfLGFoyw5cu0EvhBROaNEEqPceYvlPr0o=
Subject: Re: [PATCH 0/1] RFC: poll/select performance on datagram sockets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: jj@chaosbits.net, alban.crequy@collabora.co.uk, shemminger@vyatta.com,
        gorcunov@openvz.org, adobriyan@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pauli.nieminen@collabora.co.uk,
        rweikusat@mssgmbh.com
In-Reply-To: <20101029.134058.246543591.davem@davemloft.net>
References: <20101029191857.5f789d56@chocolatine.cbg.collabora.co.uk>
	 <1288380431.2680.3.camel@edumazet-laptop>
	 <alpine.LNX.2.00.1010292217390.24561@swampdragon.chaosbits.net>
	 <20101029.134058.246543591.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Oct 2010 22:45:16 +0200
Message-ID: <1288385116.2680.11.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 29 octobre 2010 à 13:40 -0700, David Miller a écrit :
> From: Jesper Juhl <jj@chaosbits.net>
> Date: Fri, 29 Oct 2010 22:20:12 +0200 (CEST)
> 
> > Sorry to intrude out of the blue without really understanding the kernel 
> > side of most of the code in question, but if there's a performance 
> > regression for applications using poll() shouldn't we address that so we 
> > get back to the prior performance level rather than requireing all 
> > userspace apps to switch to epoll() ??
> 
> For such a pathological program like Alban's test case, I say
> absolutely not.

Yes, and with some perf tool help, we probably can find out how to
speedup the thing again, with no API change.



