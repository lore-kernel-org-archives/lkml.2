Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab0F1H4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 03:56:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38916 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab0F1H4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 03:56:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=nrr+qGd/0Tnn3kFUbUOOHUBfSCEr9tWVNUr749+Vs7uM9clohAIyNJfMxzwPVrDFIn
         mpsNI6M5wePhel20xIBsu/7slfi3SzS5UfI1sPXkfNkRqICMO2pLSNL+J+7m/HRn0KBe
         xhvPxo+2eHkio3LKFaoj/gGyDCE4r7xSMgLEs=
Date: Mon, 28 Jun 2010 00:56:03 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
       Johannes Berg <johannes.berg@intel.com>,
       Marcel Holtmann <marcel@holtmann.org>, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] firmware: Update hotplug script, remove sysfs files
Message-ID: <20100628075603.GA25287@core.coreip.homeip.net>
References: <20100625085511.30949.41045.sendpatchset@t400s>
 <20100625182224.GA14459@kroah.com>
 <AANLkTikN_PvSmHlDfqNH1YQ5_RDCJ7k_zzzTiMs0mqP9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikN_PvSmHlDfqNH1YQ5_RDCJ7k_zzzTiMs0mqP9@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 03:17:22PM +0900, Magnus Damm wrote:
> On Sat, Jun 26, 2010 at 3:22 AM, Greg KH <greg@kroah.com> wrote:
> > On Fri, Jun 25, 2010 at 05:55:11PM +0900, Magnus Damm wrote:
> >> From: Magnus Damm <damm@opensource.se>
> >>
> >> Update the in-kernel hotplug example script to work
> >> properly with recent kernels. Without this fix the
> >> script may load the firmware twice - both at "add"
> >> and "remove" time.
> >>
> >> The second load only triggers in the case when multiple
> >> firmware images are used. A good example is the b43
> >> driver which does not work properly without this fix.
> >>
> >> While at it, make sure sysfs files are removed.
> >
> > Hm, the documentation update applied, but this second part didn't.  Care
> > to redo it against the linux-next tree and resend it as a separate
> > patch?  I've split this up and applied the documentation part now, so
> > you don't have to redo that.
> 
> Thanks a lot for splitting up the patch. I don't mind redoing the
> second part of the patch, but I'm not sure if it's actually needed to
> prevent memory leaks. This piece of code serves as an example:
> 
> +error_unreg2:
> +       sysfs_remove_bin_file(&f_dev->kobj, &fw_priv->attr_data);
>  error_unreg:
>         device_unregister(f_dev);
> 
> Perhaps device_unregister() call above already removes the kobj which
> makes the added sysfs_remove_bin_file() unnecessary?
> 

It is so happens that device_unregister() does clean up leftover sysfs
attributes but we should not rely on that happen in the future. That
said I glanced at linux-next and it appears that we do clean up the
attributes properly now.

Thanks.

-- 
Dmitry
