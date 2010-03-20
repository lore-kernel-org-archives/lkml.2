Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab0CTTyB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 15:54:01 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:3726 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235Ab0CTTyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 15:54:00 -0400
Date: Sat, 20 Mar 2010 12:54:00 -0700
From: Dmitry Torokhov <dtor@dtor-ws.eng.vmware.com>
To: Avi Kivity <avi@redhat.com>
Cc: Dmitry Torokhov <dtor@vmware.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       Alok Kataria <akataria@vmware.com>,
       Shaileshkumar Jain <sajain@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 4/4] Add VMware memory balloon driver
Message-ID: <20100320195359.GA11536@dtor-ws.eng.vmware.com>
References: <20100319204628.4418.84674.stgit@localhost.localdomain>
 <20100319204702.4418.92437.stgit@localhost.localdomain>
 <4BA4C961.9060006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA4C961.9060006@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

On Sat, Mar 20, 2010 at 06:10:57AM -0700, Avi Kivity wrote:
> On 03/19/2010 10:47 PM, Dmitry Torokhov wrote:
> > This is a virtio-based transport between VMware's hypervisor
> > and virtio_ballon driver that allows host control guest memory
> > ballooning.
> >
> >    
> 
> This is a little wierd since it's specific to the balloon driver.  The 
> virtio design is to make transport and device orthogonal so we could 
> mix'n'match any driver with any transport, but this will only work with 
> the balloon driver.  It's also 640 lines while the original balloon 
> driver is ~300.  Some of that is because you're emulating a queue that 
> doesn't really exist, IIUC.

Yes, this is corect. We have a dedicated balloon interface, so, while
trying to work with existing kernel infrastructure, we had to emulate
a virtual queue.

> 
> So while I'd love to see other hypervisors adopt virtio, I think in this 
> case it makes more sense to have your own balloon driver.
> 

Fair enough. If this is a common sentiment we'll gladly prepare our
standalone driver for submission.

Thanks.

-- 
Dmitry

