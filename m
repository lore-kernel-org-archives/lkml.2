Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab0EaRwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 13:52:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36943 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab0EaRwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 13:52:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=C5kdEuzB/NP6xp0vOpcTryWGaDVWyGSEnMSEThc94PMUNoLyvnTvt1nNzjXEiAOdPp
         6v7ABZ8gdfMiAkOq/cJH68TIHLVmpHMB4gO96UWA7PlnUZTK3zjGZinq0vHcVYsMxoJi
         lG2QPwBlG7FXg75MMLO+7xWWSKS9qKhwQNm/0=
Subject: Re: [PATCH] DM-CRYPT: Scale to multiple CPUs
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: herbert@gondor.hengli.com.au, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, agk@redhat.com, ak@linux.intel.com
In-Reply-To: <20100531174611.GF10766@basil.fritz.box>
References: <20100531160425.GA20344@basil.fritz.box>
	 <1275323695.3291.122.camel@edumazet-laptop>
	 <20100531174611.GF10766@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 19:52:08 +0200
Message-ID: <1275328328.3291.126.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 31 mai 2010 à 19:46 +0200, Andi Kleen a écrit :
> On Mon, May 31, 2010 at 06:34:55PM +0200, Eric Dumazet wrote:
> 
> Yes seems like I'm behind on per cpu innovations.
> 
> > Since commit e0fdb0e050eae331, we have a __percpu annotation so that
> > sparse can be augmented. This would also make the comment unnecessary...
> 
> I think the comment is still necessary.
> 
> > 
> > > +       __get_cpu_var(io_wq_cpu) = current;
> > 
> > 	this_cpu_write(io_wq_cpu, current)
> 
> And this one looks more ugly than before and does not seem
> to generate better code, so I decided to skip it.

This is because you whould use __this_cpu_write() in this context of
course ;)

generated code : one instruction



