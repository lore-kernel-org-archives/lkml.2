Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1EPNyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:54:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62892 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab1EPNyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:54:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qY1Aos+hRZwFkCIahDgEtJnk9xWzdFI63dN3IGT/F72afyCDqwPyHgd+fOlX7+4WMt
         UdhlDYUX5M2ctDHhL7b4dP4Na7VRVjKE02fO009E1qpOjnzCgW2v02v+9pdzZzsX2wdq
         YECBV3KtINHNo4/hTNHlGan3ws5kUOgjLnUPc=
Date: Mon, 16 May 2011 15:54:14 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: PTRACE_SEIZE should not stop  [Re: [PATCH 02/11] ptrace:
 implement PTRACE_SEIZE]
Message-ID: <20110516135414.GC23665@htj.dyndns.org>
References: <1304869745-1073-3-git-send-email-tj@kernel.org>
 <20110515155602.GD31855@host1.jankratochvil.net>
 <20110515162630.GG23665@htj.dyndns.org>
 <20110515171512.GA24047@host1.jankratochvil.net>
 <20110515172505.GL23665@htj.dyndns.org>
 <20110515194829.GA27023@host1.jankratochvil.net>
 <20110516083113.GN23665@htj.dyndns.org>
 <20110516132123.GA13544@host1.jankratochvil.net>
 <20110516134510.GA23665@htj.dyndns.org>
 <20110516134808.GA15806@host1.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516134808.GA15806@host1.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 16, 2011 at 03:48:08PM +0200, Jan Kratochvil wrote:
> On Mon, 16 May 2011 15:45:10 +0200, Tejun Heo wrote:
> > I don't think INTERRUPT can be prioritized like that above existing
> > trap conditions.  Traps are taken sometimes deep in the kernel
> > (e.g. fork/exec) and often after modifying states irrevocably
> > (e.g. signal is already dequeued on signal trap).  I don't think how
> > it would be possible to rewind the state changes and replay it later.
> 
> OK, so that closes one of the major issues I was trying to get "fixed".

Sorry, this one was too difficult and, even if somehow I pulled it,
unlikely to make upstream.  It's gonna be extremely fragile.
Unfortunately, userland would still have to deal with arbitrary order
of traps.

Thank you.

-- 
tejun
