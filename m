Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab1CGXBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:01:20 -0500
Received: from kroah.org ([198.145.64.141]:43002 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756345Ab1CGXBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:01:19 -0500
Date: Mon, 7 Mar 2011 15:00:14 -0800
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 00/16] Staging: hv: Consolidate driver and device
 abstractions
Message-ID: <20110307230014.GA9873@kroah.com>
References: <1299531695-22352-1-git-send-email-kys@microsoft.com>
 <20110307222356.GA25714@kroah.com>
 <6E21E5352C11B742B20C142EB499E0480173E9@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0480173E9@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 10:45:15PM +0000, KY Srinivasan wrote:
> > I'm guessing that you will have follow-on patches now to complete the
> > migration to the correct driver core use (i.e. proper driver and device
> > usage?)  Or do you want me to look into doing this?
> 
> My immediate goal is to get the vmbus driver to exit staging. To that
> end I am working on a patch-set to cleanup vmbus_drv.c. I should have this
> patch-set fairly soon.  Once that is
> done, I think we would have addressed all the structural/architectural issues
> of the vmbus driver that is preventing us from exiting staging. 

Well, perhaps, let's not get ahead of ourselves here :)

> We are planning to address the issues with other drivers after we are done
> with the vmbus driver. As always, your help is greatly appreciated.

The issue I am referring to above still has to do with the vmbus core.

The goal is to have the vmbus work like all other busses in the kernel.
You register a hv_driver with some probe and disconnect callbacks, and
the vmbus calls into the drivers when it needs to.

You are almost there, using the struct device pointers directly, but a
few more steps remain.

I'll look into the details after your remaining cleanups, I don't want
to get in the way of them.

thanks,

greg k-h
