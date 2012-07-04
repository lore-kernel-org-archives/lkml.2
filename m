Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2GDOwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:52:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40281 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab2GDOwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:52:49 -0400
Date: Wed, 4 Jul 2012 07:52:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com, ebiederm@xmission.com,
        luto@mit.edu, Joerg Roedel <joerg.roedel@amd.com>, dzickus@redhat.com,
        paul.gortmaker@windriver.com, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH v4 2/3] KVM-INTEL: Add new module vmcsinfo-intel to fill
 VMCSINFO
Message-ID: <20120704145245.GF23020@kroah.com>
References: <4FF413D2.4030006@cn.fujitsu.com>
 <4FF4155F.6070508@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF4155F.6070508@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 06:05:19PM +0800, Yanfei Zhang wrote:
> +int vmcs_sysfs_add(struct device *dev)
> +{
> +	return sysfs_create_group(&dev->kobj, &vmcs_attr_group);
> +}
> +
> +void vmcs_sysfs_remove(struct device *dev)
> +{
> +	sysfs_remove_group(&dev->kobj, &vmcs_attr_group);
> +}

Why are these "add" and "remove" functions here?  Shouldn't you just
write the lines out where you call them instead, as they are only called
once.

And does this race with adding new cpus to the system (is the uevent
being sent to userspace before the attributes are added?)  If so, please
fix that.

thanks,

greg k-h
