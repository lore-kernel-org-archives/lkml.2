Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab1HYNrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 09:47:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab1HYNrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 09:47:35 -0400
Date: Thu, 25 Aug 2011 10:21:11 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/11] KVM: MMU: improve write flooding detected
Message-ID: <20110825132110.GA4384@amt.cnet>
References: <4E4A1257.5080204@cn.fujitsu.com>
 <20110823080024.GA2297@amt.cnet>
 <4E53872B.3070407@cn.fujitsu.com>
 <20110823123818.GB4261@amt.cnet>
 <4E53D620.9030304@cn.fujitsu.com>
 <20110823190939.GA10220@amt.cnet>
 <4E540AB4.6060905@cn.fujitsu.com>
 <20110824200540.GA19804@amt.cnet>
 <20110825020424.GA2542@amt.cnet>
 <4E55D2A2.7050808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E55D2A2.7050808@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 07:42:10AM +0300, Avi Kivity wrote:
> On 08/25/2011 05:04 AM, Marcelo Tosatti wrote:
> >>
> >>  It could increase the flood count independently of the accessed bit of
> >>  the spte being updated, zapping after 3 attempts as it is now.
> >>
> >>  But additionally reset the flood count if the gpte appears to be valid
> >>  (points to an existant gfn if the present bit is set, or if its zeroed).
> >
> >Well not zero, as thats a common pattern for non ptes.
> >
> 
> On 32-bit with 4GB RAM, practically anything is a valid gpte.

The following could be required to consider a valid gpte, for write
flood detection purposes:

- Must be present.
- PageCacheDisable must be unset.
- PageWriteThrough must be unset.


