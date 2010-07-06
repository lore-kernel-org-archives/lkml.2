Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab0GFHoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 03:44:55 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:38045 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab0GFHoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 03:44:54 -0400
Date: Tue, 6 Jul 2010 09:46:41 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dan Kruchinin <dkruchinin@acm.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH 1/3] padata: separate serial and parallel cpumasks
Message-ID: <20100706074641.GS10072@secunet.com>
References: <AANLkTikeDE4hvZ3spyTBSHZsdQPc-2wlD5nTfb1aF-VD@mail.gmail.com>
 <20100702085323.GF10072@secunet.com>
 <AANLkTinyPGjXjlvJxB8WYB3EYFBtANXMzpTdUixyBRHW@mail.gmail.com>
 <20100702091726.GH10072@secunet.com>
 <AANLkTiltuZTkG5ZoG4TG9fA0anwRLFa__lHLnZpY2n4U@mail.gmail.com>
 <20100702111138.GI10072@secunet.com>
 <AANLkTimEgKGJ5pi7GzOnvP42ivJ4GCKX59LdKK0x4fnx@mail.gmail.com>
 <20100706053612.GQ10072@secunet.com>
 <20100706054406.GR10072@secunet.com>
 <AANLkTil4pbOOVvhIKN1_sI8kNdBFFebMVEGEmqrb45YR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTil4pbOOVvhIKN1_sI8kNdBFFebMVEGEmqrb45YR@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 06 Jul 2010 07:44:44.0418 (UTC) FILETIME=[19AC0620:01CB1CDF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 11:40:11AM +0400, Dan Kruchinin wrote:
> >> >
> >>
> >> I think we can use RCU anyway. For instance we could use a structure
> >>
> >> struct pcrypt_cpumask {
> >>       cpumask_var_t           pmask;
> >>       cpumask_var_t           smask;
> >> };
> >>
> >> and add a pointer to a structure of that type to the instance context.
> >> Then we could use this pointer for RCU and replace the whole structure
> >> if a cpumask changes.
> 
> But is pcrypt interested pmask? If it isn't, pmask field will be unused.
> 

It's probaply not, in this case the struct could look like

struct pcrypt_cpumask {
	cpumask_var_t           smask;
};
