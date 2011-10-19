Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab1JSPcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 11:32:09 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:21735 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752311Ab1JSPcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 11:32:07 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: X7HOnm4VM1mqYDGbQ.HyFE1ZeKL3JkQsIQhTBx0rDI.Q7eP
 weNxg4_zbqKW1Eq_5krKkgIzwMhZd86B2mN3_W03FN9vtg22vS5Sn0xLJIUS
 sJJirJu.laxXjCN8AsMCeDhAw7998BqFFjaMbYGsmV6LdFVAnbz7gKYDzcY6
 mNlQeNlG52WitEK1zNMzQYb.QNlw_xoEh_VYM75nn_rYjbQTYT5Wn8qDJXDw
 BZh.A8ZxlQpPPwJpG8TqgXZcWxCDHdrE5I_9zc2x3msqy0v8BkifISAQN53Y
 xYFtHI8vOV5aGLuXGQ7FzknphjB1NTODUGzBEtXCkWV_UglGLaKtZul.x0Xe
 2o4vzKLhyFNd.2sxaz6l7hG7cIZyMcdhPSeyKyzPfa3Eo3GUsNJBTcZQf13z
 RnCwzWuAXB6q9izJ_urH7J2g-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 19 Oct 2011 10:31:54 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Dimitri Sivanich <sivanich@sgi.com>
cc: David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] Reduce vm_stat cacheline contention in
 __vm_enough_memory
In-Reply-To: <20111019145458.GA9266@sgi.com>
Message-ID: <alpine.DEB.2.00.1110191029570.24001@router.home>
References: <20111014122506.GB26737@sgi.com> <20111014135055.GA28592@sgi.com> <alpine.DEB.2.00.1110140856420.6411@router.home> <20111014141921.GC28592@sgi.com> <alpine.DEB.2.00.1110140932530.6411@router.home> <alpine.DEB.2.00.1110140958550.6411@router.home>
 <20111014161603.GA30561@sgi.com> <20111018134835.GA16222@sgi.com> <m2mxcyz4f7.fsf@firstfloor.org> <alpine.DEB.2.00.1110181806570.12850@chino.kir.corp.google.com> <20111019145458.GA9266@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Oct 2011, Dimitri Sivanich wrote:

> For 120 threads writing in parallel (each to it's own mountpoint), the
> threshold needs to be on the order of 1000.  At a threshold of 750, I
> start to see a slowdown of 50-60 MB/sec.
>
> For 400 threads writing in parallel, the threshold needs to be on the order
> of 2000 (although we're off by about 40 MB/sec at that point).
>
> The necessary deltas in these cases are quite a bit higher than the current
> 125 maximum (see calculate*threshold in mm/vmstat.c).
>
> I like the idea of having certain areas triggering vm_stat sync, as long
> as we know what those key areas are and how often they might be called.

You could potentially reduce the maximum necessary by applying my earlier
patch (but please reduce the counters touched to the current cacheline).
That should reduce the number of updates in the global cacheline and allow
you to reduce the very high deltas that you have to deal with now.

