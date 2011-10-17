Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab1JQPMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:12:12 -0400
Received: from mail.vyatta.com ([76.74.103.46]:50289 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab1JQPMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:12:10 -0400
Date: Mon, 17 Oct 2011 08:12:05 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Daniel Baluta <dbaluta@ixiacom.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Mihai Maruseac <mihai.maruseac@gmail.com>, davem@davemloft.net,
        mirq-linux@rere.qmqm.pl, therbert@google.com, jpirko@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mihai Maruseac <mmaruseac@ixiacom.com>
Subject: Re: [PATCH] dev: use ifindex hash for dev_seq_ops
Message-ID: <20111017081205.2e41d03f@nehalam.linuxnetplumber.net>
In-Reply-To: <CAEnQRZCWBhTy24WkWoC_wy11YuLxWQ3GWr3v1=JcGvprq4AtmA@mail.gmail.com>
References: <1318413446-22258-1-git-send-email-mmaruseac@ixiacom.com>
	<1318586017-17207-1-git-send-email-mmaruseac@ixiacom.com>
	<1318596791.2223.13.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CAEnQRZCWBhTy24WkWoC_wy11YuLxWQ3GWr3v1=JcGvprq4AtmA@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011 11:03:54 +0300
Daniel Baluta <dbaluta@ixiacom.com> wrote:

> > This assumes device ifindexes are contained in a small range
> > [N .. N + X]
> >
> > I understand this can help some benchmarks, but in real world this wont
> > help that much once ifindexes are 'fragmented' (If really this multi
> > thousand devices stuff is for real)
> >
> > Listen, we currently have 256 slots in the hash table.
> >
> > Can we try to make 'offset' something like  (slot_number<<24) +
> > (position in hash chain [slot_number]), instead of (position in devices
> > global list)
> 
> 
> Eric, we can refine the idea of our first patch [1], where we recorded
> the (bucket, offset) pair. Stephen, do you agree with this?
> 
> 
> thanks,
> Daniel.
> 
> [1] http://patchwork.ozlabs.org/patch/118331/

Using buckets is fine, my idea about ifindex was just to try and
preserve the order, but it doesn't matter.
