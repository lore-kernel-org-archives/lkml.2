Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab2BORQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:16:15 -0500
Received: from seven.medozas.de ([188.40.89.202]:39990 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab2BORQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:16:13 -0500
Date: Wed, 15 Feb 2012 18:16:12 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Richard Weinberger <richard@nod.at>
cc: Eric Dumazet <eric.dumazet@gmail.com>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, pablo@netfilter.org, basti@b-bl.de
Subject: Re: [PATCH 2/2] Netfilter: xt_LOG: Add timestamp support
In-Reply-To: <4F3BBC11.1030308@nod.at>
Message-ID: <alpine.LNX.2.01.1202151815270.15357@frira.zrqbmnf.qr>
References: <1329314115-6899-1-git-send-email-richard@nod.at>  <1329314115-6899-2-git-send-email-richard@nod.at> <1329314492.2437.32.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <4F3BBC11.1030308@nod.at>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2012-02-15 15:07, Richard Weinberger wrote:
>>> +		struct timespec tv;
>>> +		unsigned int msec;
>>> +
>>> +		getnstimeofday(&tv);
>>> +		msec = tv.tv_nsec / NSEC_PER_MSEC;
>>> +		sb_add(m, "TIMESTAMP=%li.%03li ", tv.tv_sec, msec);
>>
>> Since you want to use this temp variable "unsigned int msec" (I have no
>> idea why...), you must change printf format accordingly : %03u instead
>> of %03li
>
> *grml*.
> I'll remove the temp variable and use %03u.

Why not just print the nsecs directly (with %09 of course)?
