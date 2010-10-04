Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab0JDTVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 15:21:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41621 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab0JDTU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 15:20:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cvBAtPw1GWuUAJu44esmU4Pz4pDf3WTPyV/GduCw/Sj/NkiG1ZgwhJT2oWeqblQ/IU
         I+wAZIDu1b6Pf7Dwj73sg+3Pl+Tr0KD9kwwF++6mi1PZvljOdot6sXZUqtKdhQjmFfMj
         ulLatjnllnu500RqaPbMpRD8EMMa6Itd90DBA=
Subject: Re: [PATCH] AF_UNIX: Implement SO_TIMESTAMP and SO_TIMETAMPNS on
 Unix sockets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alban Crequy <alban.crequy@collabora.co.uk>
Cc: Lennart Poettering <lennart@poettering.net>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <1286218109-30771-1-git-send-email-alban.crequy@collabora.co.uk>
References: <20101004194734.6a1caf3e@chocolatine.cbg.collabora.co.uk>
	 <1286218109-30771-1-git-send-email-alban.crequy@collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 21:20:52 +0200
Message-ID: <1286220052.2381.70.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 04 octobre 2010 à 19:48 +0100, Alban Crequy a écrit :
> Userspace applications can already request to receive timestamps with:
> setsockopt(sockfd, SOL_SOCKET, SO_TIMESTAMP, ...)
> 
> Although setsockopt() returns zero (success), timestamps are not added to the
> ancillary data. This patch fixes that on SOCK_DGRAM and SOCK_SEQPACKET Unix
> sockets.
> 
> Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Note: tstamp is sampled at the time of skb queueing, _after_ eventual
sleep in sock_alloc_send_skb() or memcpy_fromiovec()



