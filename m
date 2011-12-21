Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab1LUU4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 15:56:13 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:64807 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1LUU4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 15:56:08 -0500
Message-ID: <4EF24758.5030704@oracle.com>
Date: Wed, 21 Dec 2011 14:53:44 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        jfs-discussion@lists.sourceforge.net,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, davem@davemloft.net,
        Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org
Subject: Re: [PATCH v2] vfs: __read_cache_page should use gfp argument rather
 than GFP_KERNEL
References: <201112210054.46995.rjw@sisk.pl> <CA+55aFzee7ORKzjZ-_PrVy796k2ASyTe_Odz=ji7f1VzToOkKw@mail.gmail.com> <4EF15F42.4070104@oracle.com> <CA+55aFx=B9adsTR=-uYpmfJnQgdGN+1aL0KUabH5bSY6YcwO7Q@mail.gmail.com> <alpine.LSU.2.00.1112202213310.3987@eggly.anvils> <4EF211EC.7090002@oracle.com> <20111221122843.18f673c7.akpm@linux-foundation.org>
In-Reply-To: <20111221122843.18f673c7.akpm@linux-foundation.org>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4EF2475E.003D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 02:28 PM, Andrew Morton wrote:
> On Wed, 21 Dec 2011 11:05:48 -0600
> Dave Kleikamp <dave.kleikamp@oracle.com> wrote:
> 
>> [ updated to remove now-obsolete comment in read_cache_page_gfp()]
>>
>> lockdep reports a deadlock in jfs because a special inode's rw semaphore
>> is taken recursively. The mapping's gfp mask is GFP_NOFS, but is not used
>> when __read_cache_page() calls add_to_page_cache_lru().
> 
> Well hang on, it's not just a lockdep splat.  The kernel actually will
> deadlock if we reenter JFS via this GFP_KERNEL allocation attempt, yes?

Yes, it could result in a real deadlock.

> Was that GFP_NOFS allocation recently added to JFS?  If not then we
> should backport this deadlock fix into -stable, no?

Yes, that would make sense.

Shaggy
