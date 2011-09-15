Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773Ab1IONLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 09:11:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933338Ab1IONLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 09:11:38 -0400
Date: Thu, 15 Sep 2011 10:11:13 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 05/11] KVM: MMU: do not mark accessed bit on pte write
 path
Message-ID: <20110915131113.GA6933@amt.cnet>
References: <4E5C4C20.3000403@cn.fujitsu.com>
 <4E5C4C8D.5040509@cn.fujitsu.com>
 <4E6F363E.9080000@redhat.com>
 <4E6FA117.1050707@cn.fujitsu.com>
 <4E7079FD.6050506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7079FD.6050506@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 12:55:09PM +0300, Avi Kivity wrote:
> On 09/13/2011 09:29 PM, Xiao Guangrong wrote:
> >On 09/13/2011 06:53 PM, Avi Kivity wrote:
> >>  On 08/30/2011 05:35 AM, Xiao Guangrong wrote:
> >>>  In current code, the accessed bit is always set when page fault occurred,
> >>>  do not need to set it on pte write path
> >>
> >>  What about speculative sptes that are then only accessed via emulation?
> >>
> >
> >The gfn is read and written only via emulation? I think this case is very
> >very rare?
> 
> Probably...

The access information will be transferred via the host pte, via
get_user_pages, to MM layer, in that case.

> Marcelo? Can you think of another case where spte.accessed is needed?

No, an spte updated via emulation will either be accessed directly, or
if via emulation, access to the gfn it points transferred via host pte.

