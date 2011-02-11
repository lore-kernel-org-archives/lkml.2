Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab1BKJZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 04:25:21 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:45113 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab1BKJZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 04:25:18 -0500
Date: Fri, 11 Feb 2011 10:25:15 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2] flex_array: Change behaviour on zero size
 allocations
Message-ID: <20110211092515.GA29583@secunet.com>
References: <20110207122903.GO3070@secunet.com>
 <1297184561.6737.12074.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297184561.6737.12074.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Feb 2011 09:25:16.0514 (UTC) FILETIME=[97F5D420:01CBC9CD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 09:02:41AM -0800, Dave Hansen wrote:
> 
> The rest of this patch looks good.  When you resend, you need to break
> this up in to at least two patches: one to change 'end' to
> 'nr_elements' (or something else) and the one to handle zero-sized
> elements and arrays.

Ok.

> 
> I also think we need to remove the ability to do zero-sized elements.
> Unless there's some new code that I'm missing, I don't see any of the
> existing security policy code which would be able to do that.
> 

Well, from the selinux policy point of view we don't need the ability
to handle zero-sized elements. But why you want to remove it? I don't
see a reason why zero-sized elements should be handled different form
zero number of elements. This could again produce a pitfall for potential
new flex_array users.

Anyway, for the moment I'm just interested to load my selinux policy.
So we could return -EINVAL is somebody tries to allocate with element
size zero if you think it should be like that.

Steffen
