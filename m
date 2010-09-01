Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab0IAQI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 12:08:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36107 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab0IAQI4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 12:08:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oy8gRPUW6B4IXJ2Xykkhsuh1BWg6vEC86TqqSlzEg6OZbx09ofjETK9x0i8j+cKpga
         w7THpIv6tI4QWg4MrDEvYLbAWCe9Zz75w1861h9iAYY7lu7X18Ijy2ycOSEqi2xQ80N7
         V+M0gf54juTcHdh0FwpC+BZGRyBLyMSPbbRLM=
MIME-Version: 1.0
In-Reply-To: <1283287898.3284.183.camel@dhcp231-106.rdu.redhat.com>
References: <1282950052.3284.110.camel@dhcp231-106.rdu.redhat.com>
	<AANLkTi=aEdKM_hunJmPzXxPqkrbok+_C6QUKf8v=Q+18@mail.gmail.com>
	<1283210070.3284.139.camel@dhcp231-106.rdu.redhat.com>
	<4C7CC107.1050304@redhat.com>
	<4C7D0DAD.9030505@redhat.com>
	<4C7D141A.9060102@redhat.com>
	<4C7D1868.3090701@redhat.com>
	<1283267765.3284.150.camel@dhcp231-106.rdu.redhat.com>
	<4C7D1E1B.4020700@redhat.com>
	<1283268367.3284.154.camel@dhcp231-106.rdu.redhat.com>
	<4C7D248A.2080507@redhat.com>
	<AANLkTikhc1Nu5PsQqzKL0PXY3juOxwuPOsu0ZKvzfCJ3@mail.gmail.com>
	<1283287898.3284.183.camel@dhcp231-106.rdu.redhat.com>
Date: Wed, 1 Sep 2010 12:08:55 -0400
Message-ID: <AANLkTiktz6bc6Ue9OKZ0ejSqf7GH4z50JeUvidxHbrSw@mail.gmail.com>
Subject: Re: selinux vs devtmpfs (vs udev)
From: Stephen Smalley <stephen.smalley@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Harald Hoyer <harald@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov, greg@kroah.com, sds@tycho.nsa.gov
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 4:51 PM, Eric Paris <eparis@redhat.com> wrote:
> On Tue, 2010-08-31 at 21:32 +0200, Kay Sievers wrote:
>> On Tue, Aug 31, 2010 at 17:49, Harald Hoyer <harald@redhat.com> wrote:
>> > https://bugzilla.redhat.com/show_bug.cgi?id=575128#c14
>> > https://bugzilla.redhat.com/attachment.cgi?id=442223&format=raw
>> >
>> > udev/udev-node.c
>> >
>> > +                       /* set selinux file context on add events */
>> > +                       if (strcmp(udev_device_get_action(dev), "add") == 0)
>> > +                               udev_selinux_lsetfilecon(udev, file, mode);
>>
>> I can't access these bugs.
>>
>> Does that makes sense/work for you?
>>   http://git.kernel.org/?p=linux/hotplug/udev.git;a=commitdiff;h=326c5fc3ea684825629eccaf33a548759162a539
>>
>> Kay
>
> I ask Harald (but he wasn't around and I don't know the answer) if it is
> a problem that this changes the behavior of non "add" events.
> Previously a non "add" event with an incorrect mask/uid/gid would have
> reset the SELinux context but now it will not.  It fixes the issue at
> hand, my boxes boot with everything labeled nicely, but I'm not sure if
> there is some other corner case that expected the old behavior with
> change events....

Maybe we should back up and ask the udev folks how they think libvirt
labeling should be done so as to not conflict with udev labeling, e.g.
should libvirt be going through udev to assign the labels.
