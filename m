Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab2ERPWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:22:44 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45246 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513Ab2ERPWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:22:39 -0400
Subject: Re: [V2 PATCH 2/9] macvtap: zerocopy: fix truesize underestimation
From: Shirley Ma <mashirle@us.ibm.com>
To: Jason Wang <jasowang@redhat.com>
Cc: eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        davem@davemloft.net
In-Reply-To: <4FB62009.2050900@redhat.com>
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
	 <20120502034144.11782.88947.stgit@amd-6168-8-1.englab.nay.redhat.com>
	 <1337102809.8220.10.camel@oc3660625478.ibm.com>
	 <4FB3192E.4030803@redhat.com>
	 <1337180585.10741.6.camel@oc3660625478.ibm.com>
	 <4FB469A1.3040507@redhat.com>
	 <1337268512.10741.53.camel@oc3660625478.ibm.com>
	 <4FB62009.2050900@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 May 2012 08:22:31 -0700
Message-ID: <1337354551.12999.6.camel@oc3660625478.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051815-7182-0000-0000-0000018D639C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 18:10 +0800, Jason Wang wrote:
> > On Thu, 2012-05-17 at 10:59 +0800, Jason Wang wrote:
> >> Didn't see how this affact skb->len. And for truesize, I think they
> >> are
> >> different, when the offset were not zero, the data in this vector
> >> were
> >> divided into two parts. First part is copied into skb directly, and
> >> the
> >> second were pinned from a whole userspace page by
> >> get_user_pages_fast(),
> >> so we need count the whole page to the socket limit to prevent evil
> >> application.
> > What I meant that the code for skb->truesize has double added the
> first
> > offset if any left from that vector (partically copied into skb
> > directly, and then count pagesize which includes the offset
> (truesize +=
> > PAGE_SIZE)).
> 
> Yes, I get you mean. There's no difference between first frag and 
> others: it's also possible for other frags that didn't occupy the
> whole 
> page. Since we pin the whole user page, better to count the whole
> page 
> size to prevent evil application. 

The difference between first frags and others is other frags might not
occupy the whole page, but the first frags extra offset was doubled
added in skb truesize.

So it's ok for skb->truesize to be bigger than all the skb pinned pages
here?

Thanks
Shirley

