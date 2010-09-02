Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab0IBUhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:37:33 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62027 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905Ab0IBUhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:37:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Zs1LwVZKKbZ4Jv7H0gZmEfyKFXzmjxmzN8mZmrfYXR1KN+2H8UIR8v4A44JSa6CxJf
         7s/ZGQEWhtCta7gbt7IR8y370250IsGMk643O58Ye/QAL4e5XwE8vJXUJ0I/KjMe1ygl
         9PW8+TozpfxLXpgehz6Ob8FtgKTDT+XBEXIeM=
Date: Fri, 3 Sep 2010 00:36:08 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, robert.richter@amd.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org, ying.huang@intel.com,
        ming.m.lin@intel.com, yinghai@kernel.org, andi@firstfloor.org,
        eranian@google.com
Subject: Re: [PATCH 1/3] perf, x86: Fix accidentally ack'ing a second event
	on intel perf counter
Message-ID: <20100902203608.GA5914@lenovo>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com> <1283454469-1909-2-git-send-email-dzickus@redhat.com> <20100902192627.GB5538@lenovo> <20100902200021.GO4879@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100902200021.GO4879@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 04:00:21PM -0400, Don Zickus wrote:
> On Thu, Sep 02, 2010 at 11:26:27PM +0400, Cyrill Gorcunov wrote:
> > Lets assume 1 counters is triggered and global bit is set as well
> > 
> > we have here
> > 
> > 	status = intel_pmu_get_status();
> > 
> > >  	perf_sample_data_init(&data, 0);
> > >  
> > > @@ -728,6 +728,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
> > >  
> > >  	loops = 0;
> > >  again:
> > > +	intel_pmu_ack_status(status);
> > 
> > So here we write just being read value back to CTRL register and _if_ new
> > overflow happened in this window we've cleared it without processing.
> 
> No, you have to write a '1' to clear.  If a new bit is set after we read
> it, then our 'status' var should have a '0' in that bit and thus will not
> get cleared when we ack it.
> 

Yeah, messed {0;1} values, thanks!

> Cheers,
> Don
> 
	-- Cyrill
