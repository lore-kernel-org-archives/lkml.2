Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab2JNQhW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 12:37:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012Ab2JNQhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 12:37:21 -0400
Date: Sun, 14 Oct 2012 13:36:16 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 1/5] KVM: MMU: fix release noslot pfn
Message-ID: <20121014163615.GA29071@amt.cnet>
References: <50716EE0.6010504@linux.vnet.ibm.com>
 <50716F1E.90308@linux.vnet.ibm.com>
 <20121010151125.GA28406@amt.cnet>
 <5076C444.8080309@gmail.com>
 <20121011143152.GA8665@amt.cnet>
 <5077E7AA.9070705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5077E7AA.9070705@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 05:49:30PM +0800, Xiao Guangrong wrote:
> On 10/11/2012 10:31 PM, Marcelo Tosatti wrote:
> > On Thu, Oct 11, 2012 at 09:06:12PM +0800, Xiao Guangrong wrote:
> >> On 10/10/2012 11:11 PM, Marcelo Tosatti wrote:
> >>
> >>>
> >>> Why does is_error_pfn() return true for mmio spte? Its not an "error",
> >>> after all. 
> >>>
> >>> Please kill is_invalid_pfn and use
> >>>
> >>> -> is_error_pfn for checking for errors (mmio spte is not an error pfn,
> >>> its a special pfn)
> >>>
> >>> -> add explicit is_noslot_pfn checks where necessary in the code
> >>> (say to avoid interpreting a noslot_pfn's pfn "address" bits).
> >>>
> >>> (should have noticed this earlier, sorry).
> >>
> >> Never mind, your comments are always appreciated! ;)
> >>
> >> Marcelo, is it good to you?
> >> (will post it after your check and full test)
> > 
> > Yes, this works (please check the validity of each case in addition to
> > testing, haven't done it).
> > 
> > Also add a oneline comment on top of each
> > is_error_pfn,is_noslot_pfn,is_error_noslot_pfn
> > 
> > /* is_noslot_pfn: userspace translation valid but no memory slot */
> > /* is_error_pfn: ... */
> > 
> > etc.
> > 
> 
> Marcelo, i think this fix should be backport and your idea can be a
> separate patchset. Yes?

The current invalid/is_error/noslot_pfn separation is confusing, leading 
to one immediate bug and IMO more future bugs.

The proposed patch you sent is quite small, why is it troublesome to
backport? (and i am just asking one line of comment, summing to 3 total
of lines of comments).

Can't see the advantage of a special easily backportable fix?

