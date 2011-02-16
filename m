Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751019Ab1BPFJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 00:09:50 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:43615 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab1BPFJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 00:09:48 -0500
Date: Wed, 16 Feb 2011 10:39:41 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
Cc: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Subject: Re: Mapping memory between kernel and user space
Message-ID: <20110216050941.GB28895@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <AANLkTi=Ca4Lcc_war-atpr81eJcZA3ks+EKFf9Rq5pKs@mail.gmail.com>
 <20110215055426.GA468@in.ibm.com>
 <AANLkTikkLuCeWpHBU5HO=39vO_DjhQkFMmnpB4kqtEmD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikkLuCeWpHBU5HO=39vO_DjhQkFMmnpB4kqtEmD@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Feb 15, 2011 at 12:15:08PM -0500, Sri Ram Vemulpali wrote:
> As was suggested I started reading chap 15v from LDD. I ran more into
> confusion state.
> 
> I know that virtual address(process space), linear address
> (segmentation) and physical address. And how are they resolved from
> virtual to physical.
> But coming to kernel they distinguish logical address from virtual
> address. What is the main difference.
> Also, they emphasize on high memory and low memory. Why can not high
> memory can be mapped in to kernel completely.
> Why is that kernel has less visibility of complete space available on RAM.
> Linux MM is it a very specific implementation of linux, or Is that a
> traditional implementation.
> 

You may want to go through the literature available on the VM subsystem.
Especially, Mel Gorman's book:

http://ptgmedia.pearsoncmg.com/images/0131453483/downloads/gorman_book.pdf

> what is very minimal implementation of MMU for real time systems.
>

Linux VM subsystem for the RT kernel is not different from traditional
one. The application has to ensure that it pins/locks its pages during
execution.
 
> Thanks in advance.
> 
> --Sri.
> 
> On Tue, Feb 15, 2011 at 12:54 AM, Ankita Garg <ankita@in.ibm.com> wrote:
> > On Wed, Feb 09, 2011 at 06:45:42PM -0500, Sri Ram Vemulpali wrote:
> >> Hi all,
> >>
> >>   How do I map some space between kernel and user space. Can anyone
> >> point me in to right direction. I was trying to map the packets from
> >> my netfilter function to kernel user space, to avoid over head of
> >> copying. Thanks in advance.
> >>
> >
> > You can take a look at remap_pfn_range() routine when implementing mmap
> > in your driver.
> >
> > --
> > Regards,
> > Ankita Garg (ankita@in.ibm.com)
> > Linux Technology Center
> > IBM India Systems & Technology Labs,
> > Bangalore, India
> >
> 
> 
> 
> -- 
> Regards,
> Sri.

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs,
Bangalore, India
