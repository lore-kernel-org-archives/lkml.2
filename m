Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab0CVQgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:36:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54740 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab0CVQgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:36:11 -0400
Date: Mon, 22 Mar 2010 17:36:09 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Add PGM protocol support to the IP stack
Message-ID: <20100322163609.GZ20695@one.firstfloor.org>
References: <alpine.DEB.2.00.1003181245050.23010@router.home> <87tysccjrn.fsf@basil.nowhere.org> <alpine.DEB.2.00.1003220916170.15360@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003220916170.15360@router.home>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 09:20:42AM -0500, Christoph Lameter wrote:
> On Fri, 19 Mar 2010, Andi Kleen wrote:
> 
> > Christoph Lameter <cl@linux-foundation.org> writes:
> > >
> > > I know about the openpgm implementation. Openpbm does this at the user
> > > level and requires linking to a library. It is essentially a communication
> > > protocol done in user space. It has privilege issues because it has to
> > > create PGM packets via a raw socket.
> >
> > That seems like a poor reason alone to put something into the kernel
> > Perhaps you rather need some way to have unpriviledged raw sockets?
> 
> Not the only reason. There are also performance implications. NAKing and
> other control messages from user space are a pain and the available
> implementations add numerous threads just to control the timing of control
> messages and the expiration of data etc. Its difficult to listen to a PGM
> port from user space. You have to get all messages for the PGM protocol
> and then filter in each process.

Ok that sounds like a good reason to have a kernel protocol.
Thanks.

Multicast reliable kernel protocols are somewhat new, I guess one
would need to make sure to come up with a clean generic interface 
for them first.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
