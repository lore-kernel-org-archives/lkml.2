Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760438Ab0JISnF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 14:43:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756915Ab0JISnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 14:43:03 -0400
Message-ID: <4CB0B778.6060005@redhat.com>
Date: Sat, 09 Oct 2010 20:42:00 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 03/12] Retry fault before vmentry
References: <1286207794-16120-1-git-send-email-gleb@redhat.com> <1286207794-16120-4-git-send-email-gleb@redhat.com> <4CADBD13.4040609@redhat.com> <20101007172152.GB2397@redhat.com>
In-Reply-To: <20101007172152.GB2397@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/07/2010 07:21 PM, Gleb Natapov wrote:
> On Thu, Oct 07, 2010 at 02:29:07PM +0200, Avi Kivity wrote:
> >   On 10/04/2010 05:56 PM, Gleb Natapov wrote:
> >  >When page is swapped in it is mapped into guest memory only after guest
> >  >tries to access it again and generate another fault. To save this fault
> >  >we can map it immediately since we know that guest is going to access
> >  >the page. Do it only when tdp is enabled for now. Shadow paging case is
> >  >more complicated. CR[034] and EFER registers should be switched before
> >  >doing mapping and then switched back.
> >
> >  With non-pv apf, I don't think we can do shadow paging.  The guest
> Yes, with non-pv this trick will not work without tdp. I haven't even
> considered it for that case.
>

What about nnpt?  The same issues exist.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

