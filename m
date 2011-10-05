Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab1JEHJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 03:09:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48211 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab1JEHJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 03:09:31 -0400
Subject: Re: [RFCv3][PATCH 4/4] show page size in /proc/$pid/numa_maps
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
        hpa@zytor.com
In-Reply-To: <alpine.DEB.2.00.1110042344250.16359@chino.kir.corp.google.com>
References: <20111001000856.DD623081@kernel>
	 <20111001000900.BD9248B8@kernel>
	 <alpine.DEB.2.00.1110042344250.16359@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 09:09:24 +0200
Message-ID: <1317798564.3099.12.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 04 octobre 2011 à 23:50 -0700, David Rientjes a écrit :

> This would be great if all the /proc/pid/numa_maps consumers were human, 
> but unfortuantely that's not the case.  
> 
> I understand that this patchset was probably the result of me asking for 
> the pagesize= to be specified in each line and using pagesize=4K and 
> pagesize=2M as examples, but that exact usage is probably not what we 
> want.
> 
> As long as there are scripts that go through and read this information 
> (we have some internally), expressing them with differing units just makes 
> it more difficult to parse.  I'd rather them just be the byte count.
> 
> That way, 1G pages would just show pagesize=1073741824.  I don't think 
> that's too long and is much easier to parse systematically.
> 

Hmm... Thats sounds strange.

Are you saying you cant change your scripts [But you'll have to anyway
to parse pagesize=] ?

I routinely use "cat /proc/xxx/numa_maps", and am stuck when a kernel
displays nothing (it happened on some debian released kernels)

Seeing pagesize=1GB is slightly better for human, and not that hard to
parse for a program.

By the way, "pagesize=4KiB" are just noise if you ask me, thats the
default PAGE_SIZE. This also breaks old scripts :)



