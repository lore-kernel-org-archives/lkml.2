Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510Ab2C1UFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 16:05:34 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42625 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2C1UFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 16:05:33 -0400
Subject: Re: [REGRESSION][PATCH] bpf_jit drops the ball on indirect
 negative mem references
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jan Seiffert <kaffeemonster@googlemail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, Matt Evans <matt@ozlabs.org>
In-Reply-To: <CAPwCz79wO=5zTZmCG+ePfRuEu-p_Vosi18bYZ-MVNZGOdbE3aQ@mail.gmail.com>
References: <CAPwCz79wO=5zTZmCG+ePfRuEu-p_Vosi18bYZ-MVNZGOdbE3aQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Mar 2012 22:05:29 +0200
Message-ID: <1332965129.2325.12.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 21:15 +0200, Jan Seiffert wrote:
> Consider the following test program:
> 
> #include <stdio.h>
> #include <sys/types.h>
> #include <sys/socket.h>
> #include <netinet/in.h>
> #include <pcap-bpf.h>
> 
> #define die(x) do {perror(x); return 1;} while (0)
> struct bpf_insn udp_filter[] = {
> 	/*   0 */ BPF_STMT(BPF_LDX|BPF_W|BPF_IMM, -1048576+(0)), /* leax	net[0] */
> 	/*   1 */ BPF_STMT(BPF_LD|BPF_B|BPF_IND, 0),             /* ldb	[x+0] */
> 	/*   2 */ BPF_STMT(BPF_RET|BPF_A, 0),                    /* ret	a */
> };

When this point was raised some weeks ago, we wanted to see a _real_ use
of negative mem reference.

You provide a test program but what this filter is supposed to do
exactly ?



