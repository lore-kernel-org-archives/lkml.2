Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab0KLRtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:49:50 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39404 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab0KLRts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:49:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MK4dTZJtoZM3wf34UC+/v8CY/nwlR04nwovML05auWV/Q6sD2lzCxdu8ZNMPZP/6t9
         Lyn6ZEVHAw9OsFSkVFeXnE0wmBMC0zriwJhc9WP/7JMTQUPxFjqw6x/1Lr4T61SBHwAq
         9JzOAFG1ObGk6RoZsiAwHwZshcQIFpHkGCsw4=
MIME-Version: 1.0
In-Reply-To: <AANLkTikUjYUR-WguZ999YtyWLc8+U0184y0Sb6SSSgKz@mail.gmail.com>
References: <AANLkTinOeby9P847gJFn_t0h5nDY7cfi3cW9hEaUrS1v@mail.gmail.com>
	<20101106050721.GA2194@kroah.com>
	<AANLkTinQK_9qp-8jJ5j3-ChUjwhGiGzAmCu5cBtHX75g@mail.gmail.com>
	<AANLkTikdr=nJF45QUCKAOY8NSh9GNtv8c9K_oNdJeJfc@mail.gmail.com>
	<20101111010841.GA23127@kroah.com>
	<AANLkTikUjYUR-WguZ999YtyWLc8+U0184y0Sb6SSSgKz@mail.gmail.com>
Date: Fri, 12 Nov 2010 09:49:46 -0800
Message-ID: <AANLkTi=J4Y5K8wm6PGf+B2F1-CCqX--RWHeS3YbkBP60@mail.gmail.com>
Subject: Re: [RFC] rbd sysfs interface
From: Yehuda Sadeh Weinraub <yehudasa@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: ceph-devel@vger.kernel.org, Sage Weil <sage@newdream.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 9:16 PM, Yehuda Sadeh Weinraub
<yehudasa@gmail.com> wrote:
> On Wed, Nov 10, 2010 at 5:08 PM, Greg KH <greg@kroah.com> wrote:
>>
>> So, back to sysfs.  But I can't recall what your sysfs interface looked
>> like, do you have Documentation/ABI/ files that show what it does?  If
>> not, you are required to, so you might as well write them now :)
>>
>
> The original sysfs interface is described in the rbd.c prefix
> comments, which we can copy to Documentation/ABI without much pain.
> However, we were just thinking of modifying it a bit, as described
> previously in my first email. The hierarchy will look like this:
>
> rbd/
>    add
>    remove
>    <id>/
>      name
>      pool
>      size
>      ..
>      snap_add
>      snap_remove
>      snap_rollback
>        <snap_name>/
>          size
>
> The 'add' entry will be used to add a device (as before):
>
>  # echo "10.0.0.1 name=admin rbd myimage" > /sys/class/rbd/add
>
> The devices that'll be created still be enumerated, and there'll be a
> subdirectory under rbd/ for each (actually a soft link to
> /sys/devices/virtual/rbd/<id>). For each device we'll have multiple
> read-only properties (name, pool, size, client_id, major, cur_snap)
> and a few control entries (e.g., snap_add, snap_remove, etc.)
>
> There will be a subdirectory per snapshot under each device, and all
> the snapshots properties will be kept there.
>

Unless I hear otherwise, I'm going to assume that this proposed
interface is an improvement over the existing osdblk-based one and get
this upstream asap..

Thanks,
Yehuda
