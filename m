Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab0KLQPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:15:39 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:50671 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab0KLQPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:15:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=r1ziAXm6IApki/eA6Pe78jFhHTFtmffkovsHSSsa6BOwJDmUii1I9PvojvHgqnDOE4
         KB0/Lc0FyLruDMrayn+8dtWKvhbxcz1HZ05AUfNsLZDALfvxZWj7VPNtxVgG3YUAiNpu
         HJulle6QIQP5WZMl8GqFKZHvKm5+SuAbws4ts=
Subject: RE: [RFC PATCH] network: return errors if we know tcp_connect
 failed
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: Hua Zhong <hzhong@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, paul.moore@hp.com
In-Reply-To: <1289578108.3083.95.camel@localhost.localdomain>
References: <20101111210341.31350.86916.stgit@paris.rdu.redhat.com>
	 <00c201cb81eb$84e18160$8ea48420$@com>
	 <1289578108.3083.95.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 17:15:32 +0100
Message-ID: <1289578532.3185.265.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 12 novembre 2010 à 11:08 -0500, Eric Paris a écrit :

> 2) What should the generic TCP code (tcp_connect()) do if the skb failed
> to send.  Should it return error codes back up the stack somehow or
> should they continue to be ignored?  Obviously continuing to just ignore
> information we have doesn't make me happy (otherwise I wouldn't have
> started scratching this itch).  But the point about ENOBUFS is well
> taken.  Maybe I should make tcp_connect(), or the caller to
> tcp_connect() more intelligent about specific error codes?
> 
> I'm looking for a path forward.  If SELinux is rejecting the SYN packets
> on connect() I want to pass that info to userspace rather than just
> hanging.  What's the best way to accomplish that?
> 

Eric, if you can differentiate a permanent reject, instead of a
temporary one (congestion, or rate limiting, or ENOBUF, or ...), then
yes, you could make tcp_connect() report to user the permanent error,
and ignore the temporary one.



