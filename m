Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab0F1GR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 02:17:26 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60163 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab0F1GRZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 02:17:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wWQwFjZIvTs3Uues8UkAOgI186o8azwrvuc9BrX52VeBMy1KhDkNJs/jL5Bq5F9In3
         tQcKDCtARrMlD/sNy/zYVnzHlBTVif0qNF6m3j0R4+OEvpimdaK4jG1ymj8kmQ3fdXMp
         0bEdnC2xPRshSORPI8gjsKKh9eaBzB85KYipk=
MIME-Version: 1.0
In-Reply-To: <20100625182224.GA14459@kroah.com>
References: <20100625085511.30949.41045.sendpatchset@t400s>
	<20100625182224.GA14459@kroah.com>
Date: Mon, 28 Jun 2010 15:17:22 +0900
Message-ID: <AANLkTikN_PvSmHlDfqNH1YQ5_RDCJ7k_zzzTiMs0mqP9@mail.gmail.com>
Subject: Re: [PATCH] firmware: Update hotplug script, remove sysfs files
From: Magnus Damm <magnus.damm@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
       Johannes Berg <johannes.berg@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
       Marcel Holtmann <marcel@holtmann.org>, Ming Lei <tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 26, 2010 at 3:22 AM, Greg KH <greg@kroah.com> wrote:
> On Fri, Jun 25, 2010 at 05:55:11PM +0900, Magnus Damm wrote:
>> From: Magnus Damm <damm@opensource.se>
>>
>> Update the in-kernel hotplug example script to work
>> properly with recent kernels. Without this fix the
>> script may load the firmware twice - both at "add"
>> and "remove" time.
>>
>> The second load only triggers in the case when multiple
>> firmware images are used. A good example is the b43
>> driver which does not work properly without this fix.
>>
>> While at it, make sure sysfs files are removed.
>
> Hm, the documentation update applied, but this second part didn't.  Care
> to redo it against the linux-next tree and resend it as a separate
> patch?  I've split this up and applied the documentation part now, so
> you don't have to redo that.

Thanks a lot for splitting up the patch. I don't mind redoing the
second part of the patch, but I'm not sure if it's actually needed to
prevent memory leaks. This piece of code serves as an example:

+error_unreg2:
+       sysfs_remove_bin_file(&f_dev->kobj, &fw_priv->attr_data);
 error_unreg:
        device_unregister(f_dev);

Perhaps device_unregister() call above already removes the kobj which
makes the added sysfs_remove_bin_file() unnecessary?

Cheers,

/ magnus
