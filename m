Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab0FCANM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 20:13:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28834 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313Ab0FCANL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 20:13:11 -0400
MIME-Version: 1.0
Message-ID: <a9f0652d-7607-4e3f-a453-b37a1b0b4d94@default>
Date: Wed, 2 Jun 2010 17:10:36 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
       hugh.dickins@tiscali.co.uk, ngupta@vflare.org, JBeulich@novell.com,
       chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, npiggin@suse.de, riel@redhat.com,
       avi@redhat.com, pavel@ucw.cz, konrad.wilk@oracle.com
Subject: RE: [PATCH V2 1/4] Frontswap (was Transcendent Memory): swap data
 structure changes
References: <20100528174041.GA28176@ca-server1.us.oracle.com
 20100602122910.71f981e8.akpm@linux-foundation.org>
In-Reply-To: <20100602122910.71f981e8.akpm@linux-foundation.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4C06F35D.00E0:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > --- linux-2.6.34/include/linux/swap.h	2010-05-16 15:17:36.000000000
> -0600
> > +++ linux-2.6.34-frontswap/include/linux/swap.h	2010-05-24
> 10:13:41.000000000 -0600
> > @@ -182,6 +182,8 @@ struct swap_info_struct {
> >  	struct block_device *bdev;	/* swap device or bdev of swap file
> */
> >  	struct file *swap_file;		/* seldom referenced */
> >  	unsigned int old_block_size;	/* seldom referenced */
> > +	unsigned long *frontswap_map;	/* frontswap in-use, one bit per
> page */
> > +	unsigned int frontswap_pages;	/* frontswap pages in-use counter
> */
> 
> Is a 32-bit uint large enough?  Maybe there are other things in swap
> which restrict us to less than 16TB, dunno.

Yes, the same data structure has "unsigned int pages" which is
the "total of usable pages" in the swap device.  If/when
"pages" changes to an unsigned long (or long long), then
"frontswap_pages" should change also.

Thanks,
Dan
