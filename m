Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab1JQID5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 04:03:57 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53842 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab1JQIDz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 04:03:55 -0400
MIME-Version: 1.0
In-Reply-To: <1318596791.2223.13.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1318413446-22258-1-git-send-email-mmaruseac@ixiacom.com>
	<1318586017-17207-1-git-send-email-mmaruseac@ixiacom.com>
	<1318596791.2223.13.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Date: Mon, 17 Oct 2011 11:03:54 +0300
X-Google-Sender-Auth: vC2ew4MBlpTpp2JVJdbJI5KrxH0
Message-ID: <CAEnQRZCWBhTy24WkWoC_wy11YuLxWQ3GWr3v1=JcGvprq4AtmA@mail.gmail.com>
Subject: Re: [PATCH] dev: use ifindex hash for dev_seq_ops
From: Daniel Baluta <dbaluta@ixiacom.com>
To: Eric Dumazet <eric.dumazet@gmail.com>, shemminger@vyatta.com
Cc: Mihai Maruseac <mihai.maruseac@gmail.com>, davem@davemloft.net,
        mirq-linux@rere.qmqm.pl, therbert@google.com, jpirko@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mihai Maruseac <mmaruseac@ixiacom.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This assumes device ifindexes are contained in a small range
> [N .. N + X]
>
> I understand this can help some benchmarks, but in real world this wont
> help that much once ifindexes are 'fragmented' (If really this multi
> thousand devices stuff is for real)
>
> Listen, we currently have 256 slots in the hash table.
>
> Can we try to make 'offset' something like  (slot_number<<24) +
> (position in hash chain [slot_number]), instead of (position in devices
> global list)


Eric, we can refine the idea of our first patch [1], where we recorded
the (bucket, offset) pair. Stephen, do you agree with this?


thanks,
Daniel.

[1] http://patchwork.ozlabs.org/patch/118331/
