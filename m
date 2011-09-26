Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab1IZM4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 08:56:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab1IZM4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 08:56:34 -0400
Date: Mon, 26 Sep 2011 08:55:46 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        avi@redhat.com, jeremy@goop.org
Subject: Re: [V6][PATCH 4/6] x86, nmi:  add in logic to handle multiple
 events and unknown NMIs
Message-ID: <20110926125546.GD5795@redhat.com>
References: <1316805435-14832-1-git-send-email-dzickus@redhat.com>
 <1316805435-14832-5-git-send-email-dzickus@redhat.com>
 <1317027554.9084.71.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317027554.9084.71.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 10:59:14AM +0200, Peter Zijlstra wrote:
> On Fri, 2011-09-23 at 15:17 -0400, Don Zickus wrote:
> > +       /*
> > +        * Use 'false' as back-to-back NMIs are dealt with one level up.
> > +        * Of course this makes having multiple 'unknown' handlers useless
> > +        * as only the first one is ever run (unless it can actually determine
> > +        * if it caused the NMI)
> > +        */
> > +       handled = nmi_handle(NMI_UNKNOWN, regs, false); 
> 
> Shouldn't we then also add something like:
> 
> WARN_ON_ONCE(type == NMI_UNKNOWN && !list_empty(&desc->head));

That would make sense.

Cheers,
Don
