Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab1CQTah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:30:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:44103 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab1CQTae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:30:34 -0400
Date: Thu, 17 Mar 2011 12:22:24 -0700
From: Greg KH <gregkh@suse.de>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        dzickus@redhat.com
Subject: Re: [PATCH]: SMBIOS: Add initial code and export version via sysfs
Message-ID: <20110317192224.GA30105@suse.de>
References: <20110317135754.25241.88177.sendpatchset@prarit.bos.redhat.com>
 <20110317190932.074949b4@lxorguk.ukuu.org.uk>
 <4D825D32.1080309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D825D32.1080309@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 03:12:50PM -0400, Prarit Bhargava wrote:
> 
> 
> On 03/17/2011 03:09 PM, Alan Cox wrote:
> >> +static struct class smbios_class = {
> >> +	.name = "smbios",
> >> +	.dev_release = (void(*)(struct device *)) kfree,

Wait, what?  Heh, nice try, you can't do this.  If you can, your code is
doing something really wrong.  Or hacky like trying to put the device
structure as the first thing in your structure.  If that gets moved,
this will break badly.  Don't.

> >> +};
> >>     
> > I thought the policy was no new classes- Greg ?
> >   
> 
> Greg, eventually the SMBIOS code could replace the mixed DMI/SMBIOS code
> we have right now.  If there is a "no new classes" policy, could you
> give me an idea of what I should do/use instead?  The DMI stuff is
> currently in its own class ...

Ideally you should use a bus instead.  Let me go look at your original
patch and get back to you on this...

thanks,

greg k-h
