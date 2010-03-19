Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab0CSVxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 17:53:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52446
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752732Ab0CSVxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 17:53:14 -0400
Date: Fri, 19 Mar 2010 14:53:36 -0700 (PDT)
Message-Id: <20100319.145336.226782717.davem@davemloft.net>
To: andi@firstfloor.org
Cc: cl@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Add PGM protocol support to the IP stack
From: David Miller <davem@davemloft.net>
In-Reply-To: <87tysccjrn.fsf@basil.nowhere.org>
References: <alpine.DEB.2.00.1003181245050.23010@router.home>
	<87tysccjrn.fsf@basil.nowhere.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Fri, 19 Mar 2010 18:18:36 +0100

> Christoph Lameter <cl@linux-foundation.org> writes:
>>
>> I know about the openpgm implementation. Openpbm does this at the user
>> level and requires linking to a library. It is essentially a communication
>> protocol done in user space. It has privilege issues because it has to
>> create PGM packets via a raw socket.
> 
> That seems like a poor reason alone to put something into the kernel
> Perhaps you rather need some way to have unpriviledged raw sockets?
> 
> The classical way to do this is to start suid root, only open
> the socket and then drop privileges.

I completely agree.

We should be able to make a way for unprivileged users to
use RAW sockets in some limited capacity, for cases like this.

But I also don't consider what openpbm has to do right now to
be all that much of a restriction.  You need privileges to
add the protocol to the kernel, you need privileges to run
the userspace variant, there is no real difference.
