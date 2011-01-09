Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1AIWal (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:30:41 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43186 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab1AIWaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:30:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PWI79NuFIplqk/S4mEaM4S9kSwrD4U9c0XW28ilus+hrgDjI6sql2ydwLrYGuqIKGo
         z8cxXSFLnw1FEEtfifTgOVXqdOA5GUMnyeDwS50vZSsme+L0pJDmUwRcf7qcdiG5Nr1b
         jdwTvHOrhdkJFvdULRTN5MNJVpYiZiL21zkpo=
Date: Mon, 10 Jan 2011 00:30:33 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Christoph Paasch <christoph.paasch@uclouvain.be>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cleanup include/net/tcp.h include-files and
 coding-style
Message-ID: <20110109223033.GA9485@p183.telecom.by>
References: <1294606534-28522-1-git-send-email-christoph.paasch@uclouvain.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294606534-28522-1-git-send-email-christoph.paasch@uclouvain.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 09, 2011 at 09:55:34PM +0100, Christoph Paasch wrote:
> This patch reviews the include-files of net/tcp.h
> Several #include where redundant. Some where not directly needed by
> net/tcp.h
> 
> Files, including net/tcp.h where also including some the *.h-files that
> net/tcp.h is already including. Thus, in these files the inclusion of
> the *.h file is unnecessary.
> 
> Redundant includes in net/tcp.h:
> 
> linux/list.h --- included by linux/textsearch.h which is included by
>                  linux/skbuff.h
> linux/slab.h --- included by linux/crypto.h
> linux/cache.h --- included by linux/skbuff.h
> linux/skbuff.h --- included by net/sock.h
> linux/kref.h --- included by linux/kobject.h, which is  included by
>                  linux/device.h, which is included by
>                  linux/dmaengine.h, which is included by
>                  linux/skbuff.h
> net/inet_connection_sock.h --- included by net/inet_hashtables.h
> net/checksum.h --- included by net/sock.h
> net/request_sock.h --- included by net/inet_connection_sock.h
> net/sock.h --- included by net/request_sock.h
> net/snmp.h --- included by net/ip.h
> net/dst.h --- included by net/sock.h
> linux/seq_file.h --- included by net/neighbour.h, which is included by
>                      net/dst.h
> 
> Include-files not directly needed by net/tcp.h:
> 
> linux/percpu.h
> linux/dmaengine.h

DMA stuff "dereferenced" in tcp_prequeue_init().

> net/tcp_states.h
> net/inet_ecn.h

NAK

Where is the logic?

include/net/tcp.h _does_ use kref, so it needs kref.h
include/net/tcp.h _does_ use list_head, so it needs list.h

and so on.
