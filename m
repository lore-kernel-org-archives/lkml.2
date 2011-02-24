Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab1BXB2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 20:28:30 -0500
Received: from kroah.org ([198.145.64.141]:46408 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217Ab1BXB23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 20:28:29 -0500
Date: Wed, 23 Feb 2011 17:29:24 -0800
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Hank Janssen <hjanssen@microsoft.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 2/6] Staging: hv: hv.c Removed all DPRINT and debug -
 using pr_err now
Message-ID: <20110224012924.GA16496@kroah.com>
References: <1298417565-12356-1-git-send-email-hjanssen@microsoft.com>
 <1298417565-12356-2-git-send-email-hjanssen@microsoft.com>
 <20110223191533.GB1030@kroah.com>
 <8AFC7968D54FB448A30D8F38F259C56233FADA94@TK5EX14MBXC118.redmond.corp.microsoft.com>
 <20110223215658.GB16908@kroah.com>
 <8AFC7968D54FB448A30D8F38F259C56233FAE0E8@TK5EX14MBXC118.redmond.corp.microsoft.com>
 <1298509049.32283.21.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298509049.32283.21.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 04:57:29PM -0800, Joe Perches wrote:
> On Wed, 2011-02-23 at 23:17 +0000, Hank Janssen wrote:
> > > -----Original Message-----
> > > From: Greg KH [mailto:greg@kroah.com]
> > > Sent: Wednesday, February 23, 2011 1:57 PM
> > > They where compile and run tested. And syslog was not a mess. What did
> > > > I mess up here? The amount of printouts now are a fraction of what
> > > > they where before.
> > > You forgot to put '\n' at the end of all of your pr_XXX lines, so they will be
> > > merged with the next one, messing up your syslog.  Joe also pointed this
> > > problem out.
> > > Take a look at your syslog to see what I am talking about...
> 
> Greg, there probably isn't any problem with his syslog.
> 
> Running together of messages without terminating newlines
> did used to happen though until commit
> 5fd29d6ccbc98884569d6f3105aeca70858b3e0f
> ("printk: clean up handling of log-levels and newlines")
> changed behavior so that newlines are emitted if necessary
> before every "<.>" loglevel but "<c>".
> 
> That means that adding trailing newlines to pr_<level>
> calls aren't _really_ necessary unless the pr_<level>
> is followed by a bare printk without KERN_<LEVEL>.

Ah, I didn't realize that this had changed, my mistake, nevermind :)

> I still think it's better from a style perspective to keep
> adding terminating newlines until most all of the printks
> are converted to pr_<level>.

Yes, that would be good to have done.

thanks,

greg k-h
