Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab1FRIgH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 04:36:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56131 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab1FRIgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 04:36:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=k0Jy480rwSDB/GdHgzDAmsiAOlzfU9/1fRWx6igIEaTU7VrX6IHYU5rHIqhlOW5A87
         99wsKQVaq2gSmSOK2VWplQtLDuDte87ozyg0TP9qWNg7Cf9kwGg+mcFNIqYjAf4rqgSJ
         DFrWT9pPPg6qUP1ln7dpEyVHDrPnbiau7uYh4=
Date: Sat, 18 Jun 2011 10:35:59 +0200
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com, pedro@codesourcery.com
Subject: Re: [PATCH 2/5] ptrace: implement PTRACE_SEIZE
Message-ID: <20110618083559.GK2611@htj.dyndns.org>
References: <1308043218-23619-1-git-send-email-tj@kernel.org>
 <1308043218-23619-3-git-send-email-tj@kernel.org>
 <201106180955.37531.vda.linux@googlemail.com>
 <201106180959.38847.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106180959.38847.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jun 18, 2011 at 09:59:38AM +0200, Denys Vlasenko wrote:
> ...unless we plan to introduce PTRACE_O_TRACESTOP (with value 0x00000080)
> which enables PTRACE_INTERRUPT and stop notifications independently
> of PTRACE_SEIZE. Which would be very useful for e.g. strace.

I know you're a big fan of those option flags but I don't really see
the added value in making these behaviors optional rather than keeping
things backward compatible - ie. introducing new event needed to be
gated somehow so the O flags but SEIZE itself serves as a big gate
anyway so I don't see much point in introducing multiple selectable
behaviors.  It's not like PTRACE_O_TRACESTOP is gonna make anything
drastically easier or reduce significant amount of overhead.

Thanks.

-- 
tejun
