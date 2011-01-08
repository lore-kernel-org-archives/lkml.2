Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750925Ab1AHF5K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 00:57:10 -0500
Received: from cantor.suse.de ([195.135.220.2]:46578 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773Ab1AHF5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 00:57:09 -0500
Date: Fri, 7 Jan 2011 21:56:21 -0800
From: Greg KH <gregkh@suse.de>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: kobject_put vs module unload
Message-ID: <20110108055621.GB10391@suse.de>
References: <Pine.LNX.4.64.1101072234040.382@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1101072234040.382@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 10:42:22PM -0500, Mikulas Patocka wrote:
> Hi
> 
> I'm looking at some kobject problem in device mapper and I came across 
> this problem:
> 
> According to kobject interface specification, If we embed a kobject into 
> the device structure, we shouldn't free the device structure when the 
> device is unloaded, but we should register a "release" callback in 
> kobj_type that will actually free the device structure.

That is correct.

What does "device is unloaded" mean?  That really doesn't mean anything
in reference to the driver model/kobject code.

> What happens in this scenario?:
> 
> 1) someone references a device kobject
> 2) the device is unloaded (but the device structure is still in memory 
> because of that reference)

What do you mean here?  How can a device be "unloaded"?  Is it just
unregistered?

> 3) the driver module is unloaded

Oops, you just lost.

> 4) the reference obtained at point 1) is dropped, kobject reference count 
> reaches zero and the release callback is called. But that callback points 
> to an unloaded module and causes a crash.
> 
> How is it solved? Am I missing something?

You have the code that creates and frees the object, to not be in the
module that could have been unloaded.  It's really just that simple.

Hope this helps,

greg k-h
