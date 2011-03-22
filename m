Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab1CVNnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 09:43:41 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:18210 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab1CVNni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 09:43:38 -0400
Message-ID: <4D88A789.7040809@tilera.com>
Date: Tue, 22 Mar 2011 09:43:37 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Darren Hart <dvhart@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH] arch/tile: fix futex sanitization definition/prototype
 mismatch
References: <201103191553.p2JFrWG9010986@farm-0023.internal.tilera.com> <4D880D6E.9000501@linux.intel.com>
In-Reply-To: <4D880D6E.9000501@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/2011 10:46 PM, Darren Hart wrote:
> On 03/19/2011 08:45 AM, Chris Metcalf wrote:
>> Commit 8d7718aa082aaf30a0b4989e1f04858952f941bc changed "int"
>> to "u32" in the prototypes but not the definition.
>> I missed this when I saw the patch go by on LKML.
>>
>> We cast "u32 *" to "int *" since we are tying into the underlying
>> atomics framework, and atomic_t uses int as its value type.
>>
>> Signed-off-by: Chris Metcalf<cmetcalf@tilera.com>
>
> Should we have caught this with a compiler warning (mismatch definition
> and prototype) ? If not, why not?
>
> Compile and boot tested?
>
> Acked-by: Darren Hart <dvhart@linux.intel.com>

Thanks for the acked-by, though it's already been pushed up to Linus's tree
(after I got the Reviewed-by from Michel).

The problem is that Michel provided the suggested change to the tile tree,
and I acked it for him back when it was being reviewed, but I missed that
he didn't change both prototype and definition since I didn't actually try
to build it in my tree.  Instead I caught it next time I synced up my tree,
and that's when I pushed the fix above.

I'm not sure if Michel tried builds on more than one architecture or not,
but even if he had wanted to do a tile build, it's still trickier than
other architectures, since Tilera is still in the process of pushing the
tile changes for binutils and gcc back to the community.  There are
tarballs and instructions for building our cross-tools on our website
(http://www.tilera.com/scm) but I doubt many kernel submitters are willing
to build up a whole separate framework for build-testing our architecture.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

