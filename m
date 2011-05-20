Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935444Ab1ETJNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 05:13:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37297 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934436Ab1ETJNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 05:13:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WZS1bt8nrkWsfbVGlbcQlYce5pgXxzXaf/FgV+mHSnLJNInlOA0mS2+g3vmhb/LuEc
         iQVplguUNl4aBCAi6yiDgkiqFT2eYSLJdcNfuGjoba1Rgfy2xibRDMNvuKaztJMOmVJE
         E/hON6VbHZ9kAzRoiHYnvSxXTVIsXeouKiuz8=
Date: Fri, 20 May 2011 11:12:56 +0200
From: Tejun Heo <tj@kernel.org>
To: Pedro Alves <pedro@codesourcery.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, oleg@redhat.com,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110520091256.GD31426@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <201105200000.18310.pedro@codesourcery.com>
 <201105200344.44520.vda.linux@googlemail.com>
 <201105200956.23320.pedro@codesourcery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105200956.23320.pedro@codesourcery.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, May 20, 2011 at 09:56:22AM +0100, Pedro Alves wrote:
> > Ptrace API never allowed poking of running tracees.
> 
> Which is a bit lame.

Lame as it may be, it would be quite challenging to change that.

> > You need to stop it first.
> 
> That was my point...  I was just pointing out that GDB will end
> up PTRACE_INTERRUPTing the target anyway.  Maybe we could extend
> GDB's "observer" mode to be even more observer-only, and delay
> reading the DSO list and whatever else GDB does on attach until
> the first stop, or to user request.  Some archs need reading
> registers as soon as possible in order to actually know which
> arch variant we've attached to.  Anyway, this is GDBs business.
> SEIZE not interrupting won't hurt GDB, and is obviously useful for
> some use cases and tracers, _provided the race with SETOPTS is fixed_.

Other than the to-be-removed SIGTRAP, I don't think the trace is
observable from userland.  Do you have anything specific on mind?

Thanks.

-- 
tejun
