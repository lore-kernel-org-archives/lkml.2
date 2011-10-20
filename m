Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab1JTVRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:17:39 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12127 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab1JTVRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:17:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type;
	b=bkv4doMKtEQlCVPPFe1uStomjOSYZVcODUkY/sSmShB+egutahGM5IJ5GVtFtezB9
	HeKLz+dDXqql0QBUs0Xsw==
Date: Thu, 20 Oct 2011 14:17:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        Tejun Heo <htejun@gmail.com>
cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: at kernel/lockdep.c:690 __lock_acquire+0x168/0x164b()
In-Reply-To: <20111020190701.GB3586@swordfish.minsk.epam.com>
Message-ID: <alpine.DEB.2.00.1110201412070.5552@chino.kir.corp.google.com>
References: <20111015201239.GA3475@swordfish> <alpine.DEB.2.00.1110151436420.15894@chino.kir.corp.google.com> <20111015222324.GA16432@liondog.tnic> <alpine.DEB.2.00.1110151529570.25063@chino.kir.corp.google.com> <20111020183913.GA21918@liondog.tnic>
 <20111020185329.GA3586@swordfish.minsk.epam.com> <20111020190701.GB3586@swordfish.minsk.epam.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Oct 2011, Sergey Senozhatsky wrote:

> > > FWIW,
> > > 
> > > the box has been running here with f59de8992aa6 reverted for a couple of
> > > days now and no sign of the warning. I'll keep watching it but it looks
> > > ok so far, so David, you could've nailed it.
> > > 
> > 
> > Hello,
> > Well, the same with me. My laptop has been running with reverted f59de8992aa6 without any
> > problems so far. Yet, I'm not sure I understand how memset() and loop could
> > produce different results.
> > 
> 
> Oh, well, nevermind I think I get it. 
> 
> Reverting opens https://bugzilla.kernel.org/show_bug.cgi?id=35532 again.  
> 

I don't know what that is since bugzilla.kernel.org is down :)  The 
problem is that the memset(), in addition to all the other fields in 
lockdep_map, clears the "name" field, which is what the scheduler uses 
via lock_set_sublcass() to prevent this lockdep warning.  My initial 
speculation seems to be confirmed since either you or Borislav have been 
able to reproduce the warning since removing the memset().

Tejun, would you like to revert f59de8992aa6 ("lockdep: Clear whole 
lockdep_map on initialization") since it fixes this lockdep warning?
