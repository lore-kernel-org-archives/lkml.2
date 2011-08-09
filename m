Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab1HIPEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:04:44 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:49150 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab1HIPEn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:04:43 -0400
MIME-Version: 1.0
Message-ID: <ce8cba73-ec3c-42ae-849a-11db1df8ffa3@default>
Date: Tue, 9 Aug 2011 08:03:43 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: hannes@cmpxchg.org, jackdachef@gmail.com, hughd@google.com,
        jeremy@goop.org, npiggin@kernel.dk, linux-mm@kvack.org,
        akpm@linux-foundation.org, sjenning@linux.vnet.ibm.com,
        Chris Mason <chris.mason@oracle.com>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Kurt Hackel <kurt.hackel@oracle.com>, riel@redhat.com,
        ngupta@vflare.org, linux-kernel@vger.kernel.org, matthew@wil.cx
Subject: RE: Subject: [PATCH V6 1/4] mm: frontswap: swap data structure
 changes
References: <20110808204555.GA15850@ca-server1.us.oracle.com
 4E414320020000780005057E@nat28.tlf.novell.com>
In-Reply-To: <4E414320020000780005057E@nat28.tlf.novell.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E414C5E.0090:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > --- linux/include/linux/swap.h	2011-08-08 08:19:25.880690134 -0600
> > +++ frontswap/include/linux/swap.h	2011-08-08 08:59:03.952691415 -0600
> > @@ -194,6 +194,8 @@ struct swap_info_struct {
> >  	struct block_device *bdev;	/* swap device or bdev of swap file */
> >  	struct file *swap_file;		/* seldom referenced */
> >  	unsigned int old_block_size;	/* seldom referenced */
> 
> #ifdef CONFIG_FRONTSWAP
> 
> > +	unsigned long *frontswap_map;	/* frontswap in-use, one bit per page */
> > +	unsigned int frontswap_pages;	/* frontswap pages in-use counter */
> 
> 
> #endif
> 
> (to eliminate any overhead with that config option unset)
> 
> Jan

Hi Jan --

Thanks for the review!

As noted in the commit comment, if these structure elements are
not put inside an #ifdef CONFIG_FRONTSWAP, it becomes
unnecessary to clutter the core swap code with several ifdefs.
The cost is one pointer and one unsigned int per allocated
swap device (often no more than one swap device per system),
so the code clarity seemed more important than the tiny
additional runtime space cost.

Do you disagree?

Thanks,
Dan
