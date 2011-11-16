Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab1KPGTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 01:19:30 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46527 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab1KPGT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 01:19:29 -0500
Date: Wed, 16 Nov 2011 10:19:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] Checkpoint/Restore: Show in proc IDs of objects that
 can be shared between tasks
Message-ID: <20111116061923.GB15492@moon>
References: <4EC24E9E.8040502@parallels.com>
 <20111116054427.GA14827@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111116054427.GA14827@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 09:44:27PM -0800, Matt Helsley wrote:
...
> > 
> > The object address is XOR-ed with a "random" value of the same size and then
> > shown in proc. Providing this poison is not leaked into the userspace then
> > ID seem to be safe.
> 
> Really? There's no way to quickly derive the random number from known
> allocation patterns and thereby break the obfuscation scheme?
> To start we can note that the low N bits are directly exposed in the ID
> of anything that requires 2^N-byte alignment.
> 
> I think it's really a question of whether the high order bits can be derived.
> 

Good point. I suppose we might use 2 random numbers here, one for xor and
second to shuffle bits.

> And of course the random number only needs to be derived once per boot
> before it reveals the address of everything with an ID.

	Cyrill
