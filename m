Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab0EJVoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 17:44:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756598Ab0EJVoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 17:44:14 -0400
Date: Mon, 10 May 2010 23:41:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Ingo Molnar <mingo@elte.hu>,
       Mathias Krause <Mathias.Krause@secunet.com>,
       Roland McGrath <roland@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] swapper fixes (Was: kernel panic on kill(0,
	SIGTERM) with PGID == 0)
Message-ID: <20100510214134.GA9318@redhat.com>
References: <4BE01C86.3050908@secunet.com> <20100509184510.GA15219@redhat.com> <4BE7B3BD.70901@secunet.com> <20100510194917.GA5249@redhat.com> <20100510140820.0e84ecc8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510140820.0e84ecc8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10, Andrew Morton wrote:
>
> On Mon, 10 May 2010 21:49:17 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Hello,
> >
> > Mathias Krause reports that a buggy (or special) /sbin/init can
> > crash the kernel if it sends a signal to its pgrp/sid before it
> > changes its initial (0,0) pids. See the changelog for 1/4.
> >
> > git-bisect blames "start the global /sbin/init with 0,0 special pids"
> > commit 430c623121ea88ca80595c99fdc63b7f8a803ae5, but in fact the
> > problem was caused by another change, see 2/4.
> >
> > The patches do not depend on each other, 3/4 fixes another problem,
> > 4/4 is purely cosmetic.
> >
>
> Do you see a need to merge these into 2.6.34?  (I don't)

No, the problem is minor, it is not possible to exploit it unless
/sbin/init does "bad things".

And the long CC asks for review. Although 1/4 is "obviously good" in
any case and I strongly believe 2/4 is right at least in general.

Oleg.

