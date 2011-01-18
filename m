Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab1ARRYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 12:24:42 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58129 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1ARRYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 12:24:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nkVBZAAxDJT6MuuU9MxAdLWxbYkABguQjYCy+buLxYiwWRXc6h3DOs579+2VJKbBbm
         xrA2Sphtrgeq54KdZ05YuFQimhUoB2b90+Aq/H5ATQaSRQscxu0TGEHfvyCG9XZfT0Zc
         qBVR8EkFp/QoHADwFcMfaWzb1ErU8WW5tmPMg=
Subject: Re: [PATCH] af_unix: implement socket filter
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ian Molton <ian.molton@collabora.co.uk>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        ebiederm@xmission.com, xemul@openvz.org, davidel@xmailserver.org,
        Alban Crequy <alban.crequy@collabora.co.uk>
In-Reply-To: <1295368755-20931-1-git-send-email-ian.molton@collabora.co.uk>
References: <1295368755-20931-1-git-send-email-ian.molton@collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 18:22:41 +0100
Message-ID: <1295371361.3290.15.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 18 janvier 2011 à 16:39 +0000, Ian Molton a écrit :
> From: Alban Crequy <alban.crequy@collabora.co.uk>
> 
> Linux Socket Filters can already be successfully attached and detached on unix
> sockets with setsockopt(sockfd, SOL_SOCKET, SO_{ATTACH,DETACH}_FILTER, ...).
> See: Documentation/networking/filter.txt
> 
> But the filter was never used in the unix socket code so it did not work. This
> patch uses sk_filter() to filter buffers before delivery.
> 
> This short program demonstrates the problem on SOCK_DGRAM.


Any idea on performance cost adding sk_filter() call ?

Hmm, looking at it, I have no idea why sk_filter() needs to block BH.

I'll send a patch to relax this requirement.


