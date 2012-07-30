Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab2G3IBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 04:01:03 -0400
Received: from ozlabs.org ([203.10.76.45]:53065 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab2G3IBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 04:01:01 -0400
Message-ID: <1343635259.10666.1.camel@concordia>
Subject: Re: [PATCH 3/4] powerpc/crypto: add 842 hardware compression driver
From: Michael Ellerman <michael@ellerman.id.au>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Date: Mon, 30 Jul 2012 18:00:59 +1000
In-Reply-To: <500964A7.1020702@linux.vnet.ibm.com>
References: <1342708961-28587-1-git-send-email-sjenning@linux.vnet.ibm.com>
	 <1342708961-28587-4-git-send-email-sjenning@linux.vnet.ibm.com>
	 <1342762410.15356.7.camel@concordia> <500964A7.1020702@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 09:01 -0500, Seth Jennings wrote:
> On 07/20/2012 12:33 AM, Michael Ellerman wrote:
> > On Thu, 2012-07-19 at 09:42 -0500, Seth Jennings wrote:
> >> This patch adds the driver for interacting with the 842
> >> compression accelerator on IBM Power7+ systems.
> > 
> > ...
> > 
> >> +struct nx842_slentry {
> >> +	unsigned long ptr; /* Absolute address (use virt_to_abs()) */
> >> /+	unsigned long len;
> >> +};
> > 
> > These days virt_to_abs() is just __pa() - ie. convert to a real address.
> 
> Thanks, I'll make that change.
> 
> Is it a blocker to the code being pulled in though? I'm
> hoping to get this in ASAP for the 3.6 merge window.  As
> this isn't a functional defect (I assume __pa() and
> virt_to_abs() still achieve the same result), can I get an
> OK from you that this isn't a blocker to the code being
> accepted?

Sorry I missed your reply. No it's not a blocker, just ugly.

I have sent a series to Ben which removes virt_to_abs() entirely, so
we'll want to make sure we fixup the nx driver before that goes in.

cheers

