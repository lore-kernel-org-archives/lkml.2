Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab0JJHfz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 03:35:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab0JJHfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 03:35:53 -0400
Date: Sun, 10 Oct 2010 09:35:29 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 03/12] Retry fault before vmentry
Message-ID: <20101010073529.GL2397@redhat.com>
References: <1286207794-16120-1-git-send-email-gleb@redhat.com>
 <1286207794-16120-4-git-send-email-gleb@redhat.com>
 <4CADBD13.4040609@redhat.com>
 <20101007172152.GB2397@redhat.com>
 <4CB0B778.6060005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB0B778.6060005@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 08:42:00PM +0200, Avi Kivity wrote:
>  On 10/07/2010 07:21 PM, Gleb Natapov wrote:
> >On Thu, Oct 07, 2010 at 02:29:07PM +0200, Avi Kivity wrote:
> >>   On 10/04/2010 05:56 PM, Gleb Natapov wrote:
> >>  >When page is swapped in it is mapped into guest memory only after guest
> >>  >tries to access it again and generate another fault. To save this fault
> >>  >we can map it immediately since we know that guest is going to access
> >>  >the page. Do it only when tdp is enabled for now. Shadow paging case is
> >>  >more complicated. CR[034] and EFER registers should be switched before
> >>  >doing mapping and then switched back.
> >>
> >>  With non-pv apf, I don't think we can do shadow paging.  The guest
> >Yes, with non-pv this trick will not work without tdp. I haven't even
> >considered it for that case.
> >
> 
> What about nnpt?  The same issues exist.
> 
I am not sure how nntp works. What is the problem there? In case of tdp
prefault instantiates page in direct_map, how nntp interfere with that?

--
			Gleb.
