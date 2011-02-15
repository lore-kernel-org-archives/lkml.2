Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab1BOThl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 14:37:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645Ab1BOThj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 14:37:39 -0500
Date: Tue, 15 Feb 2011 11:33:38 -0800
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hashir Abdi <habdi@microsoft.com>,
        Mike Sterling <Mike.Sterling@microsoft.com>
Subject: Re: [PATCH ]:Staging: hv: Allocate the vmbus irq dynamically
Message-ID: <20110215193338.GB18886@suse.de>
References: <1297782937-24082-1-git-send-email-kys@microsoft.com>
 <20110215155954.GA32313@suse.de>
 <FB42D5CCD7B5934EB1827DB5ED9B850E07085DA1@TK5EX14MBXC104.redmond.corp.microsoft.com>
 <8AFC7968D54FB448A30D8F38F259C56233F9714A@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <20110215172253.GB18437@suse.de>
 <8AFC7968D54FB448A30D8F38F259C56233F97479@TK5EX14MBXC114.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56233F97479@TK5EX14MBXC114.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 07:09:34PM +0000, Hank Janssen wrote:
> 
> > > -----Original Message-----
> > > From: Greg KH [mailto:gregkh@suse.de]
> > > Sent: Tuesday, February 15, 2011 9:23 AM
> > > > Before the end of the week I will submit two patches for this;
> > > >
> > > > 	Remove DPRINT and change it to printk
> > >
> > > No, use dev_dbg() and friends instead of "raw" printk() calls.
> > >
> > 
> > Will do, you caught me just as I was starting the conversion :)
> 
> While cleaning this up there are a few places in vmbus and channel behavior
> where it is not in a device context. Are printk's okay in that context?

No, use pr_* instead for those.  But those should be quite rare, as you
should almost always have a device you are operating on, right?

The reason you don't use "raw" printk() is the dev_dbg() and pr_debug()
calls tie into the dynamic debugging core, which you want to use, as you
don't want to roll your own special way of doing debugging.

> The three drivers network/SCSI and Block of course will use dev_XX family.

Good, but note, I think the network has their own version of this macro
as well :)

thanks,

greg k-h
