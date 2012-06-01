Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617Ab2FAM3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 08:29:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58313 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759600Ab2FAM3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 08:29:10 -0400
Date: Fri, 1 Jun 2012 21:28:52 +0900 (KST)
From: Joonsoo Kim <js1304@gmail.com>
X-X-Sender: js1304@js1304-desktop
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 4/4] slub: refactoring unfreeze_partials()
In-Reply-To: <alpine.DEB.2.00.1205171329440.12366@router.home>
Message-ID: <alpine.DEB.2.02.1206012125520.3153@js1304-desktop>
References: <1337269668-4619-1-git-send-email-js1304@gmail.com> <1337269668-4619-5-git-send-email-js1304@gmail.com> <alpine.DEB.2.00.1205171329440.12366@router.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 May 2012, Christoph Lameter wrote:

> On Fri, 18 May 2012, Joonsoo Kim wrote:
>
>> I think that these are disadvantages of current implementation,
>> so I do refactoring unfreeze_partials().
>
> The reason the current implementation is so complex is to avoid races. The
> state of the list and the state of the partial pages must be consistent at
> all times.
>
>> Minimizing code in do {} while loop introduce a reduced fail rate
>> of cmpxchg_double_slab. Below is output of 'slabinfo -r kmalloc-256'
>> when './perf stat -r 33 hackbench 50 process 4000 > /dev/null' is done.
>
> Looks good. If I can convince myself that this does not open up any
> new races then I may ack it.

This is a reminder mail.
Would u give me some comments for this please?
