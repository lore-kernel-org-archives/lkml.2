Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab2LGPE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 10:04:56 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42965 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420Ab2LGPEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 10:04:55 -0500
Date: Fri, 7 Dec 2012 07:07:04 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>, CAI Qian <caiqian@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [ 20/27] s390/mm: have 16 byte aligned struct pages
Message-ID: <20121207150704.GD20369@kroah.com>
References: <20121207005825.232489605@linuxfoundation.org>
 <20121207005831.786407731@linuxfoundation.org>
 <20121207100007.GB5129@osiris.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121207100007.GB5129@osiris.de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 11:00:07AM +0100, Heiko Carstens wrote:
> On Thu, Dec 06, 2012 at 04:59:04PM -0800, Greg Kroah-Hartman wrote:
> > 3.6-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > 
> > commit 4bffbb3455372a26816e364fb4448810f7014452 upstream.
> > 
> > Select HAVE_ALIGNED_STRUCT_PAGE on s390, so that the slub allocator can make
> > use of compare and swap double for lockless updates. This increases the size
> > of struct page to 64 bytes (instead of 56 bytes), however the performance gain
> > justifies the increased size:
> > 
> > - now excactly four struct pages fit into a single cache line; the
> >   case that accessing a struct page causes two cache line loads
> >   does not exist anymore.
> > - calculating the offset of a struct page within the memmap array
> >   is only a simple shift instead of a more expensive multiplication.
> > 
> > A "hackbench 200 process 200" run on a 32 cpu system did show an 8% runtime
> > improvement.
> > 
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Signed-off-by: CAI Qian <caiqian@redhat.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Same as for 3.4: compare and swap double is not available for 3.6 on s390.

Thanks for letting me know, and the review, much appreciated, I'll drop
these from 3.4 and 3.6 now.

CAI, your track record here isn't very good, I'm going to now require
you to get an ACK from the maintainer of all patches you are suggesting
for the stable kernels, before I will take them.  Please do that in the
future, as this has wasted a lot of developer time, myself especially.

thanks,

greg k-h
