Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760878Ab2C3OI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 10:08:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33390 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759401Ab2C3OIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 10:08:20 -0400
Subject: Re: [REGRESSION][PATCH] bpf_jit drops the ball on indirect
 negative mem references
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jan Seiffert <kaffeemonster@googlemail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, Matt Evans <matt@ozlabs.org>
In-Reply-To: <4F75B828.3090705@googlemail.com>
References: <CAPwCz79wO=5zTZmCG+ePfRuEu-p_Vosi18bYZ-MVNZGOdbE3aQ@mail.gmail.com>
	 <1332965129.2325.12.camel@edumazet-glaptop>
	 <CAPwCz7_tnjq32duJSDj21LpRe5TFvGGszH4joQr1DGTjNd7GcA@mail.gmail.com>
	 <1332967172.2325.22.camel@edumazet-glaptop>
	 <4F744D58.3070009@googlemail.com>
	 <1333098711.19659.9.camel@edumazet-laptop>
	 <4F75B828.3090705@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Mar 2012 16:08:13 +0200
Message-ID: <1333116493.2325.2125.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-30 at 15:42 +0200, Jan Seiffert wrote:

> Do you know where i can ping the powerpc guys a little bit harder?

maybe using CC linux-arch@vger.kernel.org

One way to handle that would be to split this patch in 3 parts, so that
I can Ack the non ppc part.

[1] introduce bpf_internal_load_pointer_neg_helper()
	[BTW no need to EXPORT_SYMBOL it, since jit is not a module ]

[2] x86_bpf_iit: handle negative offsets in loads

[3] ppc_bpf_jit: handle negative offsets in loads



