Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab1HIQRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:17:10 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:34600 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab1HIQRJ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:12:1>);
	Tue, 9 Aug 2011 12:17:09 -0400
Message-Id: <4E4179D90200007800050676@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 09 Aug 2011 17:18:01 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Dan Magenheimer" <dan.magenheimer@oracle.com>
Cc: <hannes@cmpxchg.org>, <jackdachef@gmail.com>, <hughd@google.com>,
        <jeremy@goop.org>, <npiggin@kernel.dk>, <linux-mm@kvack.org>,
        <akpm@linux-foundation.org>, <sjenning@linux.vnet.ibm.com>,
        "Chris Mason" <chris.mason@oracle.com>,
        "Konrad Wilk" <konrad.wilk@oracle.com>,
        "Kurt Hackel" <kurt.hackel@oracle.com>, <riel@redhat.com>,
        <ngupta@vflare.org>, <linux-kernel@vger.kernel.org>, <matthew@wil.cx>
Subject: RE: Subject: [PATCH V6 1/4] mm: frontswap: swap data structure
	 changes
References: <20110808204555.GA15850@ca-server1.us.oracle.com
 4E414320020000780005057E@nat28.tlf.novell.com><4E414320020000780005057E@nat28.tlf.novell.com>
 <ce8cba73-ec3c-42ae-849a-11db1df8ffa3@default>
In-Reply-To: <ce8cba73-ec3c-42ae-849a-11db1df8ffa3@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 09.08.11 at 17:03, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
>> > --- linux/include/linux/swap.h	2011-08-08 08:19:25.880690134 -0600
>> > +++ frontswap/include/linux/swap.h	2011-08-08 08:59:03.952691415 -0600
>> > @@ -194,6 +194,8 @@ struct swap_info_struct {
>> >  	struct block_device *bdev;	/* swap device or bdev of swap file */
>> >  	struct file *swap_file;		/* seldom referenced */
>> >  	unsigned int old_block_size;	/* seldom referenced */
>> 
>> #ifdef CONFIG_FRONTSWAP
>> 
>> > +	unsigned long *frontswap_map;	/* frontswap in-use, one bit per page */
>> > +	unsigned int frontswap_pages;	/* frontswap pages in-use counter */
>> 
>> 
>> #endif
>> 
>> (to eliminate any overhead with that config option unset)
>> 
>> Jan
> 
> Hi Jan --
> 
> Thanks for the review!
> 
> As noted in the commit comment, if these structure elements are
> not put inside an #ifdef CONFIG_FRONTSWAP, it becomes
> unnecessary to clutter the core swap code with several ifdefs.
> The cost is one pointer and one unsigned int per allocated
> swap device (often no more than one swap device per system),
> so the code clarity seemed more important than the tiny
> additional runtime space cost.
> 
> Do you disagree?

Not necessarily - I just know that in other similar occasions (partly
internally to our company) I was asked to make sure turned off
features would not leave *any* run time foot print whatsoever.

Jan

