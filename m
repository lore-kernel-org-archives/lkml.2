Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab0EOWpW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 18:45:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:53496 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab0EOWpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 18:45:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=bV/9a4LllBpz+tnWsRI+9xqJLr0jcheEuFhJsC3pHyeAHsBYDkvXnEg7l2tHIh+Np
	WhLCVP5FStgN4dVwzwzOQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTil4zgqBtBAp--P8VdynpbohxVosQ-qFiQQ_c5Bb@mail.gmail.com>
References: <1273869997-12720-1-git-send-email-gthelen@google.com> 
	<alpine.DEB.2.00.1005141626250.20193@router.home> <AANLkTil4zgqBtBAp--P8VdynpbohxVosQ-qFiQQ_c5Bb@mail.gmail.com>
From: Greg Thelen <gthelen@google.com>
Date: Sat, 15 May 2010 15:44:50 -0700
Message-ID: <AANLkTink6jV2RNoIaym4HcIx-mU1yIKURWahw8waNMQW@mail.gmail.com>
Subject: Re: [PATCH] mm: Consider the entire user address space during node 
	migration
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>, Mel Gorman <mel@csn.ul.ie>,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 15, 2010 at 7:31 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>
> Hi
>
> Mysteriously, I haven't receive original post.
> So now I'm guessing you acked following patch.
>
> http://lkml.org/lkml/2010/5/14/393
>
> but I don't think it is correct.
>
> > -     check_range(mm, mm->mmap->vm_start, TASK_SIZE, &nmask,
> > +     check_range(mm, mm->mmap->vm_start, TASK_SIZE_MAX, &nmask,
> >                       flags | MPOL_MF_DISCONTIG_OK, &pagelist);
>
> Because TASK_SIZE_MAX is defined on x86 only. Why can we ignore other platform?
> Please put following line anywhere.
>
> #define TASK_SIZE_MAX TASK_SIZE

I just send out patch v2, which uses mm->task_size rather than
TASK_SIZE_MAX.  Some non-x86 architectures do not define
TASK_SIZE_MAX, but do make TASK_SIZE depend on the current task.  So I
feel it would be better to refer to the mm struct to obtain the needed
address space limit information rather than TASK_SIZE[_MAX], which can
depend on current.

--
Greg
