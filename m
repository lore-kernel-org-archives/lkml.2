Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab1DTOPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 10:15:44 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59852 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611Ab1DTOPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 10:15:42 -0400
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        x86 maintainers <x86@kernel.org>, linux-arch@vger.kernel.org
In-Reply-To: <BANLkTim+m-v-4k17HUSOYSbmNFDtJTgD6g@mail.gmail.com>
References: <20110420102314.4604.A69D9226@jp.fujitsu.com>
	 <BANLkTi=mxWwLPEnB+rGg29b06xNUD0XvsA@mail.gmail.com>
	 <20110420161615.462D.A69D9226@jp.fujitsu.com>
	 <BANLkTimfpY3gq8oY6bPDajBW7JN6Hp+A0A@mail.gmail.com>
	 <20110420112020.GA31296@parisc-linux.org>
	 <BANLkTim+m-v-4k17HUSOYSbmNFDtJTgD6g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 09:15:37 -0500
Message-ID: <1303308938.2587.8.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added linux-arch to cc since we're going to be affecting them]
On Wed, 2011-04-20 at 14:28 +0300, Pekka Enberg wrote:
> Right. My point was simply that since x86 doesn't support DISCONTIGMEM
> without NUMA, the misunderstanding is likely very wide-spread.

Why don't we approach the problem in a few separate ways then. 

     1. We can look at what imposing NUMA on the DISCONTIGMEM archs
        would do ... the embedded ones are going to be hardest hit, but
        if it's not too much extra code, it might be palatable.
     2. The other is that we can audit mm to look at all the node
        assumptions in the non-numa case.  My suspicion is that
        accidentally or otherwise, it mostly works for the normal case,
        so there might not be much needed to pull it back to working
        properly for DISCONTIGMEM.
     3. Finally we could look at deprecating DISCONTIGMEM in favour of
        SPARSEMEM, but we'd still need to fix -stable for that case.
        Especially as it will take time to convert all the architectures

I'm certainly with Matthew: DISCONTIGMEM is supposed to be a lightweight
framework which allows machines with split physical memory ranges to
work.  That's a very common case nowadays.  Numa is supposed to be a
heavyweight framework to preserve node locality for non-uniform memory
access boxes (which none of the DISCONTIGMEM && !NUMA systems are).

James


