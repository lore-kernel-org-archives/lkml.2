Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab1FNMTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 08:19:14 -0400
Received: from smtp-out.google.com ([74.125.121.67]:33613 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab1FNMTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 08:19:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=bJpjn/ZqcQW/cJkwxyOSLoG/TbxeWEDqCBp6TaENhoJygoj4nUagf7RrvC72lOf2hH
         oPgl7QZBkQomyB/+YgVg==
Date: Tue, 14 Jun 2011 05:18:46 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Pekka Enberg <penberg@kernel.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-mm <linux-mm@kvack.org>, Christoph Lameter <cl@linux.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: fix kernel BUG at mm/slub.c:1950!
In-Reply-To: <1308027078.2874.1005.camel@pasglop>
Message-ID: <alpine.LSU.2.00.1106140515470.30002@sister.anvils>
References: <alpine.LSU.2.00.1106121842250.31463@sister.anvils> <alpine.DEB.2.00.1106131258300.3108@router.home> <1307990048.11288.3.camel@jaguar> <alpine.DEB.2.00.1106131428560.5601@router.home> <BANLkTi=RYq0Dd210VC+NeTXWWuFbz7cxeg@mail.gmail.com>
 <BANLkTik-KGtuoVFKvy_rk7voBRAxSsR9FRg0fhb0k3NCSg-fWQ@mail.gmail.com> <1308027078.2874.1005.camel@pasglop>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jun 2011, Benjamin Herrenschmidt wrote:
> On Mon, 2011-06-13 at 14:00 -0700, Hugh Dickins wrote:
> > On Mon, Jun 13, 2011 at 1:34 PM, Pekka Enberg <penberg@kernel.org> wrote:
> > > On Mon, Jun 13, 2011 at 10:29 PM, Christoph Lameter <cl@linux.com> wrote:
> > >> On Mon, 13 Jun 2011, Pekka Enberg wrote:
> > >>
> > >>> > Hmmm.. The allocpercpu in alloc_kmem_cache_cpus should take care of the
> > >>> > alignment. Uhh.. I see that a patch that removes the #ifdef CMPXCHG_LOCAL
> > >>> > was not applied? Pekka?
> > >>>
> > >>> This patch?
> > >>>
> > >>> http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=d4d84fef6d0366b585b7de13527a0faeca84d9ce
> > >>>
> > >>> It's queued and will be sent to Linus soon.
> > >>
> > >> Ok it will also fix Hugh's problem then.
> > >
> > > It's in Linus' tree now. Hugh, can you please confirm it fixes your machine too?
> > 
> > I expect it to, thanks: I'll confirm tonight.
> 
> From report to resolution before I got to read the thread, that's how I
> like them ! Thanks guys :-)

Confirmed: fixed in 3.0-rc3 - thank you!

Hugh
