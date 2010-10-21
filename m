Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab0JUNND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:13:03 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:33753 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757946Ab0JUNNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:13:01 -0400
Date: Thu, 21 Oct 2010 15:08:47 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Shan Wei <shanwei@cn.fujitsu.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>,
        Sridhar Samudrala <sri@us.ibm.com>, linux-sctp@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: remove redundant chunk length check
Message-ID: <20101021150847.3a5f3cb7@absol.kitzblitz>
In-Reply-To: <4CC02CDF.5040700@cn.fujitsu.com>
References: <20101021121409.6de7d429@absol.kitzblitz>
	<4CC02CDF.5040700@cn.fujitsu.com>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Shan Wei <shanwei@cn.fujitsu.com>:
> Nicolas Kaiser wrote, at 10/21/2010 06:14 PM:
> > Checking the chunk length at this point appears redundant, as
> > the rest of the packet gets discarded anyway.
 
> Yes, indeed.
> 
> How did you find this? By reviewing the source code?

Actually I'm tinkering with Coccinelle patches.

Here's a simple semantic patch, that will give a lot of false
positives, and a lot of "if (a) return b; return b;":

// <smpl>
@@
expression a;
statement S;
@@

- if (a)
- {
- S
- }
 S
// </smpl>

Best regards,
Nicolas Kaiser
