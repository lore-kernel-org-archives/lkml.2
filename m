Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714Ab1HZOrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:47:11 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64798 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab1HZOrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:47:09 -0400
Subject: Re: [PATCH] slab: avoid unnecessary touching of a partial slab
From: Zhao Jin <cronozhj@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: penberg@kernel.org, mpm@selenic.com, trivial@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1108260841570.5818@router.home>
References: <CADqbE97Vj0UV-2XvpkoELwdey_Xw7iCsF1AhQNFjwxY583SUwg@mail.gmail.com>
	 <alpine.DEB.2.00.1108260841570.5818@router.home>
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 26 Aug 2011 22:46:56 +0800
Message-ID: <1314370016.8991.38.camel@vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-26 at 09:08 -0500, Christoph Lameter wrote:
> On Fri, 26 Aug 2011, Zhao Jin wrote:
> 
> > In cache_alloc_refill(), after refilling from a partial slab, if the
> > slab remains partial, it would be deleted from and then added again to
> > the partial list. As the slab is the first element in the list before
> > deletion, such behavior has no effect. This patch avoids touching the
> > slab in this case.
> 
> The list_del/list_add action is a list_move.

But in cache_alloc_refill(), it is the first slab (that is: its list
field is pointed by the l3->slabs_partial.next) that is picked from the
partial list for refilling. Assume it remains partial after that. Since
list_add inserts a new element after the head (l3->slabs_partial), the
position of the slab in the partial list won't change after
list_del/list_add: it will be still the first element. Therefore,
list_del/list_add has done nothing actually in this case.

Regards,
zhj


