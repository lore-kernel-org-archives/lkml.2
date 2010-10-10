Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab0JJUYG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 16:24:06 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52201 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0JJUYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 16:24:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DRkpby7H8kQK/yCeKy9UEEfLLtxmaHQwn0BULbnE/MOBq2J7FMT5s4smPiUm09PGJ5
         +TkuT6zGRhVXFIChKHhtJ+8aIqZSZR8M37aDN+QwlbH9UEt9MMYXK6XaCPvOxUHvHsBZ
         Oudd+m+t8Gat6UtiaC2xgWbtwmuplOow8TOjA=
Date: Mon, 11 Oct 2010 00:23:57 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>,
        Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, fweisbec@gmail.com,
        robert.richter@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] arch generic way to trigger unknown NMIs
Message-ID: <20101010202357.GA28938@lenovo>
References: <20101007030807.GA4076@redhat.com> <20101007072641.GE5010@basil.fritz.box> <20101007140112.GN10663@redhat.com> <alpine.LFD.2.00.1010072342170.15889@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010072342170.15889@eddie.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 11:45:59PM +0100, Maciej W. Rozycki wrote:
> On Thu, 7 Oct 2010, Don Zickus wrote:
> 
> > No I prefer a single one too, but there didn't seem to be a
> > send_IPI_self() command, so I took the short route and sent it to
> > everyone. :-(
> 
>  Odd, APIC hardware does explicitly support such a mode (there are three 
> shorthands like this actually: all-but-self, all and self), so why don't 
> just add a suitable wrapper?
> 
>   Maciej
> 

We have send_IPI_self which can't be used for NMI delivery mode (ie with
self shortland) but still can be used as say (didn't test)

	apic->send_IPI_mask(cpumask_of(cpu), NMI_VECTOR)

where cpu is a target.

  Cyrill
