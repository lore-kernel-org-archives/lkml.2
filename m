Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab1BBHzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 02:55:24 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:52079 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab1BBHzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 02:55:22 -0500
Date: Wed, 2 Feb 2011 08:55:20 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Eric Paris <eparis@redhat.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] flex_array: Change behaviour on zero size allocations
Message-ID: <20110202075520.GN3070@secunet.com>
References: <20110131085213.GK3070@secunet.com>
 <1296491497.7797.3792.camel@nimitz>
 <20110201102417.GL3070@secunet.com>
 <20110201110311.GM3070@secunet.com>
 <1296572145.27022.2837.camel@nimitz>
 <1296573623.3145.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296573623.3145.6.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Feb 2011 07:55:21.0246 (UTC) FILETIME=[8A6983E0:01CBC2AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 10:20:22AM -0500, Eric Paris wrote:
> 
> I'm fine with any solution.  It's obviously broken for SELinux to be
> passing -1 even if the library supported it.  I guess I don't really
> have strong feelings on how to fix it.
> 
> 1) make end exclusive
> 2) change 'end' to 'len'
> 3) just make selinux not prealloc() when the #elements == 0
> 
> All seem perfectly reasonable to me, but I'd probably do them in that
> order.
> 

I think I would prefer option 2. Passing a size or a length to
a memory allocator is quite common and we would not need to care
for bugs where 'end' is smaller than 'start'.

So I'd do it like that, if noone has strong feelings for another option.

Steffen


