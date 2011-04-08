Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab1DHQnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 12:43:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60622 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757600Ab1DHQnb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 12:43:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=KilKTvVuZywvOn4qwbapvFVTqLNfEVCqr62AM7DFPYP0ggSV9B2TauB2zTKLrG9oEz
         imNO1sZxn0eG2OG1q8txW0Lz0T8vr69U6jYHMt969fZd3uc4aEZE52wvm0p2LygTmmDJ
         r50ei1+i9r7sD2YBvvrSPuczLPem6rPzz4bgo=
MIME-Version: 1.0
In-Reply-To: <20110408161420.GB12111@kroah.com>
References: <20110405124946.7969.66796.stgit@ltc233.sdl.hitachi.co.jp>
 <20110405161400.GA885@kroah.com> <4D9F17DF.5030601@hitachi.com>
 <4D9F1CD1.2020600@suse.de> <1302275652.4090.10.camel@mulgrave.site> <20110408161420.GB12111@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 8 Apr 2011 18:43:14 +0200
Message-ID: <BANLkTimUjkO4s3b1KvhNht-WCfqK+SU2NA@mail.gmail.com>
Subject: Re: [PATCH 1/2] SCSI: Add a SCSI option for persistent device names
 in Kernel.
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>,
        Nao Nishijima <nao.nishijima.xt@hitachi.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-hotplug@vger.kernel.org, Jon Masters <jcm@redhat.com>,
        2nddept-manager@sdl.hitachi.co.jp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 8, 2011 at 18:14, Greg KH <greg@kroah.com> wrote:
> On Fri, Apr 08, 2011 at 08:14:12AM -0700, James Bottomley wrote:
>> So, while I agree totally with the above: udev and userspace is the way
>> to go, I'm not totally opposed to having a non-invasive mechanism for
>> indicating a user's preferred name for a device.  I think there are a
>> couple of ways to do this:
>>
>>      1. Entirely in userspace: just have udev consult a preferred name
>>         file and create say /dev/disk/by-preferred.  Then have all the
>>         tools that normally output device information do the same (i.e.
>>         since real name to preferred name is 1:1, they could all do a
>>         reverse lookup).
>>      2. have a writeable sysfs preferred_name field, either in the
>>         generic device or just in SCSI.  The preferred name would be
>>         used by outbound only (i.e. kernel dev_printk messages and
>>         possibly /proc/partitions).  All inbound uses of the device
>>         would come via the standard udev mechanisms
>>         (i.e. /dev/disk/by-preferred would be the usual symlink).  This
>>         means from the kernel point of view, no renaming has happened.
>>         We'd just try to print out the preferred name in certain
>>         circumstances, which should solve most of the described problem.
>
> Either, or both, of those options are fine with me as well.

I guess a generic sysfs file, that can carry a user-given name for a
device, and which is looked-up with dev_printk() macro, and maybe
/proc/partitions is all what we would need if we want to involve the
kernel here.

Kay
