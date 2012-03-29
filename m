Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457Ab2C2WDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 18:03:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62844 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab2C2WDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 18:03:05 -0400
Date: Thu, 29 Mar 2012 15:03:00 -0700
From: Greg K H <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/14] edac: rewrite the sysfs code to use struct device
Message-ID: <20120329220300.GA16491@kroah.com>
References: <1333040821-6253-1-git-send-email-mchehab@redhat.com>
 <1333040821-6253-2-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
In-Reply-To: <1333040821-6253-2-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 02:06:48PM -0300, Mauro Carvalho Chehab wrote:
> +static void mci_attr_release(struct device *device)
>  {
> -	int err;
> -
> -	debugf4("%s()\n", __func__);
> -
> -	while (sysfs_attrib) {
> -		debugf4("%s() sysfs_attrib = %p\n",__func__, sysfs_attrib);
> -		if (sysfs_attrib->grp) {
> -			struct mcidev_sysfs_group_kobj *grp_kobj;
> -
> -			grp_kobj = kzalloc(sizeof(*grp_kobj), GFP_KERNEL);
> -			if (!grp_kobj)
> -				return -ENOMEM;
> -
> -			grp_kobj->grp = sysfs_attrib->grp;
> -			grp_kobj->mci = mci;
> -			list_add_tail(&grp_kobj->list, &mci->grp_kobj_list);
> -
> -			debugf0("%s() grp %s, mci %p\n", __func__,
> -				sysfs_attrib->grp->name, mci);
> -
> -			err = kobject_init_and_add(&grp_kobj->kobj,
> -						&ktype_inst_grp,
> -						&mci->edac_mci_kobj,
> -						sysfs_attrib->grp->name);
> -			if (err < 0) {
> -				printk(KERN_ERR "kobject_init_and_add failed: %d\n", err);
> -				return err;
> -			}
> -			err = edac_create_mci_instance_attributes(mci,
> -					grp_kobj->grp->mcidev_attr,
> -					&grp_kobj->kobj);
> -
> -			if (err < 0)
> -				return err;
> -		} else if (sysfs_attrib->attr.name) {
> -			debugf4("%s() file %s\n", __func__,
> -				sysfs_attrib->attr.name);
> -
> -			err = sysfs_create_file(kobj, &sysfs_attrib->attr);
> -			if (err < 0) {
> -				printk(KERN_ERR "sysfs_create_file failed: %d\n", err);
> -				return err;
> -			}
> -		} else
> -			break;
> -
> -		sysfs_attrib++;
> -	}
> -
> -	return 0;
> +	debugf1("Releasing mci device %s\n", dev_name(device));
>  }

Sweet, as per the documentation in the Documentation/kobjects.txt file,
I get to publically mock you for thinking you are smarter than the
kernel and this is an acceptable way to "outwhit" the driver core from
spitting errors at you when the kobject is released.

Please fix this up, it's unacceptable.

> +static void mc_attr_release(struct device *device)
> +{
> +	debugf1("Releasing device %s\n", dev_name(device));
> +}

Hey, you did it again, not nice :(

You also just leaked memory as well :(

Please fix.

greg k-h
