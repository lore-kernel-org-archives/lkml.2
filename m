Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab1IFRfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 13:35:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297Ab1IFRe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 13:34:57 -0400
Date: Tue, 6 Sep 2011 12:53:12 -0400
From: Don Zickus <dzickus@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [V3][PATCH 2/6] x86, nmi: create new NMI handler routines
Message-ID: <20110906165312.GQ5795@redhat.com>
References: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
 <1314290748-23569-3-git-send-email-dzickus@redhat.com>
 <20110906100857.GE14200@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110906100857.GE14200@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 12:08:57PM +0200, Robert Richter wrote:
> On 25.08.11 12:45:44, Don Zickus wrote:
> > +int register_nmi_handler(unsigned int type, nmi_handler_t handler,
> > +			unsigned long nmiflags, const char *devname)
> > +{
> > +	struct nmiaction *action;
> > +	int retval;
> > +
> > +	if (!handler)
> > +		return -EINVAL;
> > +
> > +	action = kzalloc(sizeof(struct nmiaction), GFP_KERNEL);
> > +	if (!action)
> > +		return -ENOMEM;
> > +
> > +	action->handler = handler;
> > +	action->flags = nmiflags;
> > +	action->name = kstrndup(devname, NMI_MAX_NAMELEN, GFP_KERNEL);
> 
> Null pointer check is missing here.

Thanks.

Cheers,
Don
