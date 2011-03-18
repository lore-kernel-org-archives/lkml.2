Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab1CRQzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 12:55:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16891 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186Ab1CRQzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 12:55:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=gXXkvmO0yte57LQCXGUnWV8zPx+EnJ5dS7lpgzyz9H4Aaz9l9Op/PH7prrbqSmz+UH
         RxzFR1i4jbKUxKTmC+vA==
MIME-Version: 1.0
In-Reply-To: <20110315211353.GA9992@ghc17.ghc.andrew.cmu.edu>
References: <20110208013542.GC31569@ghc17.ghc.andrew.cmu.edu>
 <20110208013950.GF31569@ghc17.ghc.andrew.cmu.edu> <AANLkTinEnNsu8=PEktXL_EECzGYqsgdf+uogGxe7k4W+@mail.gmail.com>
 <20110310061831.GA23736@ghc17.ghc.andrew.cmu.edu> <AANLkTikkmfwk0nV0p=omz2ddrw+ZqWF1Lx3EfO6dTjEQ@mail.gmail.com>
 <20110315211353.GA9992@ghc17.ghc.andrew.cmu.edu>
From: Paul Menage <menage@google.com>
Date: Fri, 18 Mar 2011 09:54:33 -0700
Message-ID: <AANLkTim4z_x_UQE__f5t73Dimja8PTTXTKKgj2phv6FY@mail.gmail.com>
Subject: Re: [PATCH v8 3/3] cgroups: make procs file writable
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        akpm@linux-foundation.org, ebiederm@xmission.com, lizf@cn.fujitsu.com,
        matthltc@us.ibm.com, oleg@redhat.com,
        David Rientjes <rientjes@google.com>, Miao Xie <miaox@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 2:13 PM, Ben Blum <bblum@andrew.cmu.edu> wrote:
>
> Hmm, you may be right; my understanding of RCU is not complete. But
> actually I think the BUG_ON should just be removed, since we're about to
> drop locks before handing off to cgroup_attach_proc anyway (so at no
> important part is the assertion guaranteed), which will detect and
> EAGAIN if such a race happened.

Sounds good.

>
> Hmm, well, should I make this assumption, then? The code would not be
> more complicated either way, really. I kind of prefer it as it is...
>

OK, I guess either way is OK until we can prove otherwise :-)

Paul
