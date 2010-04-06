Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab0DFRGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 13:06:46 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:44368 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754649Ab0DFRGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 13:06:39 -0400
Date: Tue, 6 Apr 2010 10:06:39 -0700
From: Dmitry Torokhov <dtor@vmware.com>
To: Avi Kivity <avi@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] VMware Balloon driver
Message-ID: <20100406170639.GA20948@dtor-ws.eng.vmware.com>
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com>
 <20100405142419.2c9bea3d.akpm@linux-foundation.org>
 <20100405225833.GA25970@dtor-ws.eng.vmware.com>
 <4BBB622F.4070501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBB622F.4070501@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 09:32:47AM -0700, Avi Kivity wrote:
> On 04/06/2010 01:58 AM, Dmitry Torokhov wrote:
> >
> >> Also please explain the applicability of this driver.  Will xen use it?
> >> kvm?  Out-of-tree code?
> >>      
> > The driver is expected to be used on VMware platform - mainly ESX.
> > Originally we tried to converge with KVM and use virtio and
> > stock virtio_balloon driver but Avi mentioned that our code emulating
> > virtqueue was more than balloon code itself and thus using virtio did
> > not make nuch sense.
> >    
> 
> Yeah.  If we wanted commonality, we could make a balloon_core.c that 
> contains the common code.  IMO that's premature, but perhaps there's 

I really not sure if it makes much sense. Ripping out virtdev/virtqueue
from virtio_balloon leaves pretty much nothing.

> some meat there (like suspend/resume support and /proc//sys interface).

We do not need any special suspend/resume support - the freezeable
workqueue is stopped when suspending.

Thanks.

-- 
Dmitry
