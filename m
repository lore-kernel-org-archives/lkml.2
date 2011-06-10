Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab1FJSy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 14:54:26 -0400
Received: from smtp-out.google.com ([74.125.121.67]:24842 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab1FJSyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 14:54:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=co70qOce68CEeUhL46wSyooDniNAYht0pQy/dyv+pEfxxnxpE3u7xJFefaVW5Fp32m
         VvZsKiVSvN7xry9Q57tw==
Date: Fri, 10 Jun 2011 11:54:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, tglx@linutronix.de,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, pavel@ucw.cz
Subject: Re: [PATCH] Make GFP_DMA allocations w/o ZONE_DMA emit a warning
 instead of failing
In-Reply-To: <20110610091233.GJ24424@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1106101150280.17197@chino.kir.corp.google.com>
References: <BANLkTinBkdVd90g3-uiQP41z1S1sXUdRmQ@mail.gmail.com> <BANLkTikrRRzGLbMD47_xJz+xpgftCm1C2A@mail.gmail.com> <alpine.DEB.2.00.1106011017260.13089@chino.kir.corp.google.com> <20110601181918.GO3660@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1106012043080.3078@ionos>
 <alpine.DEB.2.00.1106011205410.17065@chino.kir.corp.google.com> <alpine.LFD.2.02.1106012134120.3078@ionos> <4DF1C9DE.4070605@jp.fujitsu.com> <20110610004331.13672278.akpm@linux-foundation.org> <BANLkTimC8K2_H7ZEu2XYoWdA09-3XxpV7Q@mail.gmail.com>
 <20110610091233.GJ24424@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011, Russell King - ARM Linux wrote:

> > Should one submit a patch adding a warning to GFP_DMA allocations
> > w/o ZONE_DMA, or the idea of the original patch is wrong?
> 
> Linus was far from impressed by the original commit, saying:
> | Using GFP_DMA is reasonable in a driver - on platforms where that
> | matters, it should allocate from the DMA zone, on platforms where it
> | doesn't matter it should be a no-op.
> 
> So no, not even a warning.
> 

Any words of wisdom for users with CONFIG_ZONE_DMA=n that actually use 
drivers where they need GFP_DMA?  The page allocator should just silently 
return memory from anywhere?
