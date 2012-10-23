Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab2JWMQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 08:16:49 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:43779 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab2JWMQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 08:16:48 -0400
X-IronPort-AV: E=Sophos;i="4.80,634,1344211200"; 
   d="scan'208";a="15333182"
Date: Tue, 23 Oct 2012 13:16:18 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/19] x86, mm: setup page table in top-down
In-Reply-To: <CAE9FiQWSb5D=DZRA6AceonMwBEjEgVEodvnC0aQwa4H3v+e_2A@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1210231307440.2689@kaball.uk.xensource.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org> <1350593430-24470-10-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1210191714330.2689@kaball.uk.xensource.com> <CAE9FiQX-JBHvjqLyjutKfBUp2DQKEwVMGEkj7Wi6yijAERhP6w@mail.gmail.com>
 <alpine.DEB.2.02.1210221405010.2689@kaball.uk.xensource.com> <CAE9FiQViaompYixDoOb_XPA4Npwb0RyYu2czfpAGMGQbVSCB=A@mail.gmail.com> <CAE9FiQWSb5D=DZRA6AceonMwBEjEgVEodvnC0aQwa4H3v+e_2A@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012, Yinghai Lu wrote:
> On Mon, Oct 22, 2012 at 11:17 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Mon, Oct 22, 2012 at 6:19 AM, Stefano Stabellini
> 
> > How about put sth:
> > ---
> > Xen mmu requires pages from this function should be directly mapped already.
> > ---
> >
> > or you can introduce some doc tag specially that we can out those
> > assumption easily?
> 
> I add
> 
> /* Xen requires pages from this function should be directly mapped already */
> 
> in   [PATCH] x86, mm: Add alloc_low_pages(num)
> 
> hope you are happy with that.
> 

It is not bad, but let's just fix the English a bit and give more
context:

/* Pages returned by this function are already directly mapped.
 *
 * Changing that is likely to break Xen, see commit
 * 279b706bf800b5967037f492dbe4fc5081ad5d0f for more information on the
 * subject.
 */
