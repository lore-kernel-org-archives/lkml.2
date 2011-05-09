Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab1EIBq7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 21:46:59 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:1834 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1EIBq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 21:46:58 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: various vmbus review comments
Thread-Topic: various vmbus review comments
Thread-Index: AQHMCdM/6BBvI53KVEebJyh4jiWUR5SDpzdA
Date: Mon, 9 May 2011 01:46:56 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481E9404@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <20110503204641.GA11132@kroah.com>
In-Reply-To: <20110503204641.GA11132@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, May 03, 2011 4:47 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: various vmbus review comments
> 
> I just took a quick look at the vmbus code, and have the following
> comments:
> 	- why is count_hv_channel() even a function?


Done; I got rid of this function

> 	- your .h files need to be consolidated and renamed.  You will
> 	  need a single hyperv.h file for include/linux/ that will
> 	  contain some of what the vmbus*.h files have in it, but not
> 	  all.  Please merge things together to have:
> 	  	- include/linux/hyperv.h
> 		   What is needed to build the drivers that attach to
> 		   the bus
> 		- drivers/staging/hv/hyperv.h
> 		   The local .h file will have the vmbus*.h remaining
> 		   stuff that is only needed by the hv_vmbus.ko module
> 		   to be build.

Done; as I had informed you in an earlier mail, in addition to the two header files
you have mentioned, I have also created driver specific header files for block and
network drivers.

> 	- the instances of hv_driver structures need to be static and
> 	  not programatically defined, like all other USB and PCI
> 	  drivers are handled.

Done. You had expressed some concern that this would expose some issue
with the core vmbus driver (which is what I want to concentrate on this 
go around). I have done this for both the block driver and the mouse driver
and I am pretty sure I can do the same with the network driver. I have not 
currently done this for the network driver, since the number of patches I have 
to submit is already very large.

> 	- module reference counting.  Are you sure you got it all right
> 	  for the individual modules that attach to the bus?  I don't
> 	  see any reference counting happening, is that correct?

I have already exchanged an email with you on this. To summarize, it
does not look like there is a problem

> 	- fix the sparse warnings.
Mostly done; most of the errors are in the base kernel coming out of
the macro page_to_pfn()

> 	- fix the use of volatile in the ring buffer code.  It should
> 	  not be needed and if you are relying on it, then the code is
> 	  wrong.

You are right; all accesses were already serialized with a spin lock and the 
Volatile attribute was unnecessary.

> 	- fix the namespace on the ringbuffer code to show that it
> 	  really is only for the hyperv bus code internally.

Done.

> 
> That should be enough for at least one more set of patches for you all
> to work on :)

Greg,

I have had so much fun cleaning up these drivers that I lost track of the patch count.
I have addressed all the issues you have raised in addition to some other cleanup
that I was doing since about a week. As I look at the patch-set, I have little over 
200 patches. If it is ok with you, I would like to send them as a single set. Let me know 
what you prefer. I need to circulate these patches internally before I can send them out. 
I should be able to send these out early next week.


Regards,

K. Y
