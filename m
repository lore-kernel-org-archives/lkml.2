Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab2GEBlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 21:41:36 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:47988 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2GEBlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 21:41:35 -0400
Message-ID: <1341452486.18505.49.camel@ThinkPad-T420>
Subject: Re: [PATCH powerpc 2/2] kfree the cache name  of pgtable cache if
 SLUB is used
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm <linux-mm@kvack.org>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>
Date: Thu, 05 Jul 2012 09:41:26 +0800
In-Reply-To: <4FF439D0.1000603@parallels.com>
References: <1340617984.13778.37.camel@ThinkPad-T420>
	 <1340618099.13778.39.camel@ThinkPad-T420>
	 <alpine.DEB.2.00.1207031344240.14703@router.home>
	 <alpine.DEB.2.00.1207031535330.14703@router.home>
	 <1341392420.18505.41.camel@ThinkPad-T420> <4FF439D0.1000603@parallels.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12070501-3864-0000-0000-000003A28957
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 16:40 +0400, Glauber Costa wrote:
> On 07/04/2012 01:00 PM, Li Zhong wrote:
> > On Tue, 2012-07-03 at 15:36 -0500, Christoph Lameter wrote:
> >> > Looking through the emails it seems that there is an issue with alias
> >> > strings. 
> > To be more precise, there seems no big issue currently. I just wanted to
> > make following usage of kmem_cache_create (SLUB) possible:
> > 
> > 	name = some string kmalloced
> > 	kmem_cache_create(name, ...)
> > 	kfree(name);
> 
> Out of curiosity: Why?
> This is not (currently) possible with the other allocators (may change
> with christoph's unification patches), so you would be making your code
> slub-dependent.
> 

For slub itself, I think it's not good that: in some cases, the name
string could be kfreed ( if it was kmalloced ) immediately after calling
the cache create; in some other case, the name string needs to be kept
valid until some init calls finished. 

I agree with you that it would make the code slub-dependent, so I'm now
working on the consistency of the other allocators regarding this name
string duplicating thing. 


