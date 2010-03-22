Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab0CVOUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:20:55 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:34489 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab0CVOUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:20:53 -0400
Date: Mon, 22 Mar 2010 09:20:42 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Add PGM protocol support to the IP stack
In-Reply-To: <87tysccjrn.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.2.00.1003220916170.15360@router.home>
References: <alpine.DEB.2.00.1003181245050.23010@router.home> <87tysccjrn.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Mar 2010, Andi Kleen wrote:

> Christoph Lameter <cl@linux-foundation.org> writes:
> >
> > I know about the openpgm implementation. Openpbm does this at the user
> > level and requires linking to a library. It is essentially a communication
> > protocol done in user space. It has privilege issues because it has to
> > create PGM packets via a raw socket.
>
> That seems like a poor reason alone to put something into the kernel
> Perhaps you rather need some way to have unpriviledged raw sockets?

Not the only reason. There are also performance implications. NAKing and
other control messages from user space are a pain and the available
implementations add numerous threads just to control the timing of control
messages and the expiration of data etc. Its difficult to listen to a PGM
port from user space. You have to get all messages for the PGM protocol
and then filter in each process.

PGM operates on the same level as TCP and UDP.

> The classical way to do this is to start suid root, only open
> the socket and then drop privileges.

Yes those solutions exist and the experience with their limitations are
the reason to try to get PGM in the kernel.
