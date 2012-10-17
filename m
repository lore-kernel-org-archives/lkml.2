Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790Ab2JQUKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 16:10:21 -0400
Received: from mail.x86-64.org ([217.9.48.20]:52685 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756303Ab2JQUKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 16:10:20 -0400
Date: Wed, 17 Oct 2012 22:10:18 +0200
From: Borislav Petkov <bp@amd64.org>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Tony Luck <tony.luck@intel.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/5] drivers/base: Add a DEVICE_BOOL_ATTR macro
Message-ID: <20121017201018.GC32230@aftab.osrc.amd.com>
References: <1350472435-29307-1-git-send-email-bp@amd64.org>
 <1350472435-29307-2-git-send-email-bp@amd64.org>
 <20121017190300.GB25996@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121017190300.GB25996@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 12:03:00PM -0700, Greg Kroah-Hartman wrote:
> On Wed, Oct 17, 2012 at 01:13:51PM +0200, Borislav Petkov wrote:
> > +ssize_t device_store_bool(struct device *dev, struct device_attribute *attr,
> > +			  const char *buf, size_t size)
> > +{
> > +	struct dev_ext_attribute *ea = to_ext_attr(attr);
> > +	u8 bval;
> > +
> > +	if (kstrtou8(buf, 10, &bval) < 0)
> > +		return -EINVAL;
> > +
> > +	*(bool *)ea->var = !!bval;
> > +
> > +	return size;
> > +}
> > +EXPORT_SYMBOL_GPL(device_store_bool);
> 
> Wouldn't it be nice to be able to accept 'y' 'Y' 'n' 'N' '0' and '1'
> like the module bool parameter code does?  That would make things a bit
> more consistent, and possibly allow you to use this function for the
> module sysfs file handling as well.

That could be easily done, let me try it tomorrow. Any other letters you
prefer? Maybe, 'G' 'r' 'e' 'g'... ?

:-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
