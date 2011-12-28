Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab1L1RFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 12:05:30 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57214 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab1L1RF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 12:05:27 -0500
Date: Wed, 28 Dec 2011 21:05:21 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Message-ID: <20111228170521.GT27266@moon>
References: <20111222125639.360640574@openvz.org>
 <20111222131139.457264003@openvz.org>
 <20111228165114.04fcae0f@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111228165114.04fcae0f@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 04:51:14PM +0000, Alan Cox wrote:
> > +	  be used for anything but the "sameness" test. Besides, the IDs are
> > +	  dynamic and valid only while object is alive, once it get freed or
> 
> Please explain your locking model which ensures a false sameness cannot
> occur due to object reuse as you do the comparison and scan.
> 

It can happen in case of object re-allocated from slab. But in case
of two living pids it's impossible to get same pointers for different
objects. Or I misunderstood the question, Alan? It's up to application
to not compare objects from dead tasks.

	Cyrill
