Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab0DPH06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 03:26:58 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:44386 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab0DPH04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 03:26:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=scOs4pdiyvR6luIYj4Qmg45F+6yjhZbGDAd4yD5ZIG7ZYhrp1/KcmH7OCC9Hgea8Jm
         5DAc294lz69sDMvElZnDBFqtSE8Mdaj/G3mJ0SFTehMX/KeqBXYvMJ1Hzwnc00Sq028h
         vK3kPUOgZsRWyd1wPnaJttcevYxgy5hPm3dGg=
Date: Fri, 16 Apr 2010 09:26:52 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: useless node/has_cpu sysfs attribute
Message-ID: <20100416072652.GA4489@alberich.amd.com>
References: <20100415061200.GC21517@alberich.amd.com>
 <alpine.DEB.2.00.1004151917420.17800@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1004151917420.17800@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 07:27:42PM -0500, Christoph Lameter wrote:
> On Thu, 15 Apr 2010, Andreas Herrmann wrote:
> 
> > commit 99dcc3e5a94ed491fbef402831d8c0bbb267f995 (this_cpu: Page
> > allocator conversion) removed the call
> >
> >     node_set_state(node, N_CPU);    /* this node has a cpu */

> This was moved to vmstat_cpuup_callback. See mm/vmstat.c. Maybe it needs
> to be  added to setup_vmstat() as well.

Ok.
I missed that one.

> > Thus the sysfs attribute /sys/devices/system/node/has_cpu doesn't
> > show anything anymore.
> 
> Thats strange. Why is the cpuup notifier not executing?

I'll try to figure this out.

> > This attribute never reflected any changes triggered by CPU hotplug.
> 
> Duh some breakage in the cpuup notifier handling?
> 
> This needs to be fixed.

Why don't we try to call node_clear_state(node, N_CPU)
anywhere? (Maybe there is such a call and I missed it.)

Do we want to list each node with this attribute that has a CPU
regardless whether the CPU is actually offline or online?

That is the reason why I wanted to know who is relying on this
attribute and what are the use cases of it.


Thanks,
Andreas
