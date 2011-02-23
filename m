Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab1BWXHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 18:07:49 -0500
Received: from kroah.org ([198.145.64.141]:51652 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278Ab1BWXHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 18:07:48 -0500
Date: Wed, 23 Feb 2011 15:06:54 -0800
From: Greg KH <greg@kroah.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>, Hank Janssen <hjanssen@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 1/4] staging: hv: Fix the code depending on struct
 vmbus_driver_context data order
Message-ID: <20110223230654.GA18829@kroah.com>
References: <1298492398-16522-1-git-send-email-haiyangz@microsoft.com>
 <20110223212644.GC23766@kroah.com>
 <6E21E5352C11B742B20C142EB499E048014F2C@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20110223224829.GA7175@kroah.com>
 <A1F3067C9B68744AA19F6802BAB8FFDC060EE9@TK5EX14MBXC227.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A1F3067C9B68744AA19F6802BAB8FFDC060EE9@TK5EX14MBXC227.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 10:55:12PM +0000, Haiyang Zhang wrote:
> > From: Greg KH [mailto:greg@kroah.com]
> > The layering is almost ok, there is still one more layer here than is
> > needed, and it should be removed (I already removed lots of layers that
> > were not needed, just didn't get to this one.)  But the naming also
> > needs to be fixed up as it is wrong from a "driver model" standpoint
> > with the rest of the kernel.
> 
> So, how about rename the "struct driver_context" to "struct gen_drv_ctx"
> in this patch? We can deal with the layering in next round of patches.

No, it's not a "driver context" at all.  It is a "hyperv driver", so
name it as such.

A "context" is a void pointer or something that the driver uses
privately.  And you already have a pointer to the context in the base
structure so you don't need your own.

You should work on removing the layering now, that will clean this all
up.

thanks,

greg k-h
