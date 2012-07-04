Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab2GDMnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 08:43:42 -0400
Received: from mx2.parallels.com ([64.131.90.16]:37055 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab2GDMnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 08:43:39 -0400
Message-ID: <4FF439D0.1000603@parallels.com>
Date: Wed, 4 Jul 2012 16:40:48 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Li Zhong <zhong@linux.vnet.ibm.com>
CC: Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm <linux-mm@kvack.org>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH powerpc 2/2] kfree the cache name  of pgtable cache if
 SLUB is used
References: <1340617984.13778.37.camel@ThinkPad-T420>  <1340618099.13778.39.camel@ThinkPad-T420>  <alpine.DEB.2.00.1207031344240.14703@router.home>  <alpine.DEB.2.00.1207031535330.14703@router.home> <1341392420.18505.41.camel@ThinkPad-T420>
In-Reply-To: <1341392420.18505.41.camel@ThinkPad-T420>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2012 01:00 PM, Li Zhong wrote:
> On Tue, 2012-07-03 at 15:36 -0500, Christoph Lameter wrote:
>> > Looking through the emails it seems that there is an issue with alias
>> > strings. 
> To be more precise, there seems no big issue currently. I just wanted to
> make following usage of kmem_cache_create (SLUB) possible:
> 
> 	name = some string kmalloced
> 	kmem_cache_create(name, ...)
> 	kfree(name);

Out of curiosity: Why?
This is not (currently) possible with the other allocators (may change
with christoph's unification patches), so you would be making your code
slub-dependent.


