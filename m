Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab0IWLnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 07:43:10 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:36434 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab0IWLnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 07:43:07 -0400
Date: Thu, 23 Sep 2010 20:42:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        linux-kernel@vger.kernel.org,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Steve Wise <swise@chelsio.com>, Neil Brown <neilb@suse.de>,
        Paul Mackerras <paulus@samba.org>, linux-i2c@vger.kernel.org,
        linux-rdma@vger.kernel.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: idr_get_new_exact ?
Message-ID: <20100923114255.GB27960@linux-sh.org>
References: <AANLkTi=ZLupVyFR0e2v-TLpeNWdw1bVMZUAhgyxLJ7OV@mail.gmail.com> <adaiq20f90h.fsf@cisco.com> <4C97D197.9070703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C97D197.9070703@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 11:26:47PM +0200, Tejun Heo wrote:
> Hello,
> 
> On 09/20/2010 10:35 PM, Roland Dreier wrote:
> > Looks fine to me as an improvement over the status quo, but I wonder how
> > many of these places could use the radix_tree stuff instead?  If you're
> > not using the ability of the idr code to assign an id for you, then it
> > seems the radix_tree API is a better fit.
> 
> I agree.  Wouldn't those users better off simply using radix tree?
> 
It could go either way. I was about to write the same function when
playing with it for IRQ mapping, the idea being to propagate the initial
tree with sparse static vectors and then switch over to dynamic IDs for
virtual IRQ creation. I ended up going with a radix tree for other
reasons, though.
