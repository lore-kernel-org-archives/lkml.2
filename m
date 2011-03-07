Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab1CGWpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 17:45:18 -0500
Received: from mail2.microsoft.com ([131.107.115.215]:33670 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab1CGWpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 17:45:17 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 00/16] Staging: hv: Consolidate driver and device
 abstractions
Thread-Topic: [PATCH 00/16] Staging: hv: Consolidate driver and device
 abstractions
Thread-Index: AQHL3RZ3wHBycqZ49EOrvHzNUQlzbpQicxCQ
Date: Mon, 7 Mar 2011 22:45:15 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0480173E9@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1299531695-22352-1-git-send-email-kys@microsoft.com>
 <20110307222356.GA25714@kroah.com>
In-Reply-To: <20110307222356.GA25714@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Monday, March 07, 2011 5:24 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH 00/16] Staging: hv: Consolidate driver and device
> abstractions
> 
> On Mon, Mar 07, 2011 at 01:01:35PM -0800, K. Y. Srinivasan wrote:
> > Hyper-V has maintained both its class independent driver and
> > device state in two independent data structures:
> > Driver state: struct driver_context (vmbus.h) and struct hv_driver
> > (vmbus_api.h)
> > Device state: struct vm_device (vmbus.h) and struct hv_device (vmbus_api.h)
> >
> > While sruct driver_context and struct vm_device embed generic
> > Linux abstractions of struct device_driver and struct device respectively;
> > the lower level hyperv abstraction: struct hv_driver and struct hv_device
> > have maintained state needed to communicate with the host. This partitioning
> > made sense at a point in time when it was not clear how much of
> > the hypervisor interaction would be open sourced. Given where we are
> > today, there is no reason to keep this layering. This patchset
> > consolidates all the driver state into a single structure:
> > struct hv_driver while all the device state is consolidated into
> > a single structure: struct hv_device. This consolidation simplifies
> > the code while simultaneously getting rid of redundant state -
> > for instance in the current code, both struct driver_context and
> > struct hv_driver both have state to represent the class as well as
> > instance id. We do this consolidation by moving state from higher
> > level structures (struct driver_context and struct vm_device) to
> > lower level structures (struct hv_driver and hv_device) respectively.
> >
> > While it has not been a goal of this effort to cleanup structure and
> > variable names, this consolidation effort has resulted in some cleanup
> > with regards to structure and variable names: a) Some of the badly
> > named structures have been eliminated (struct driver_context etc.)
> > while hopefully all newly introduced names are acceptable.
> >
> > Patches 1 through 11 deal with consolidating the device driver
> > state while patches 12 through 16  deal with consolidating
> > device state.
> 
> Very nice job, now that's the way to break up and send a patch series.
> 
> I've queued them all up now.


Thanks Greg; coming from you it means a lot to me.

> 
> I'm guessing that you will have follow-on patches now to complete the
> migration to the correct driver core use (i.e. proper driver and device
> usage?)  Or do you want me to look into doing this?

My immediate goal is to get the vmbus driver to exit staging. To that
end I am working on a patch-set to cleanup vmbus_drv.c. I should have this
patch-set fairly soon.  Once that is
done, I think we would have addressed all the structural/architectural issues
of the vmbus driver that is preventing us from exiting staging. 
We are planning to address the issues with other drivers after we are done
with the vmbus driver. As always, your help is greatly appreciated.

Regards,

K. Y   

