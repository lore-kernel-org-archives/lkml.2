Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab0IAToJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 15:44:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319Ab0IAToI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 15:44:08 -0400
Message-ID: <4C7EAD03.2010005@redhat.com>
Date: Wed, 01 Sep 2010 15:44:03 -0400
From: Daniel J Walsh <dwalsh@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100624 Fedora/3.1-1.fc14 Thunderbird/3.1
MIME-Version: 1.0
To: Stephen Smalley <stephen.smalley@gmail.com>
CC: Eric Paris <eparis@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Harald Hoyer <harald@redhat.com>, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov, greg@kroah.com, sds@tycho.nsa.gov
Subject: Re: selinux vs devtmpfs (vs udev)
References: <1282950052.3284.110.camel@dhcp231-106.rdu.redhat.com>	<AANLkTi=aEdKM_hunJmPzXxPqkrbok+_C6QUKf8v=Q+18@mail.gmail.com>	<1283210070.3284.139.camel@dhcp231-106.rdu.redhat.com>	<4C7CC107.1050304@redhat.com>	<4C7D0DAD.9030505@redhat.com>	<4C7D141A.9060102@redhat.com>	<4C7D1868.3090701@redhat.com>	<1283267765.3284.150.camel@dhcp231-106.rdu.redhat.com>	<4C7D1E1B.4020700@redhat.com>	<1283268367.3284.154.camel@dhcp231-106.rdu.redhat.com>	<4C7D248A.2080507@redhat.com>	<AANLkTikhc1Nu5PsQqzKL0PXY3juOxwuPOsu0ZKvzfCJ3@mail.gmail.com>	<1283287898.3284.183.camel@dhcp231-106.rdu.redhat.com> <AANLkTiktz6bc6Ue9OKZ0ejSqf7GH4z50JeUvidxHbrSw@mail.gmail.com>
In-Reply-To: <AANLkTiktz6bc6Ue9OKZ0ejSqf7GH4z50JeUvidxHbrSw@mail.gmail.com>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 09/01/2010 12:08 PM, Stephen Smalley wrote:
> On Tue, Aug 31, 2010 at 4:51 PM, Eric Paris <eparis@redhat.com> wrote:
>> On Tue, 2010-08-31 at 21:32 +0200, Kay Sievers wrote:
>>> On Tue, Aug 31, 2010 at 17:49, Harald Hoyer <harald@redhat.com> wrote:
>>>> https://bugzilla.redhat.com/show_bug.cgi?id=575128#c14
>>>> https://bugzilla.redhat.com/attachment.cgi?id=442223&format=raw
>>>>
>>>> udev/udev-node.c
>>>>
>>>> +                       /* set selinux file context on add events */
>>>> +                       if (strcmp(udev_device_get_action(dev), "add") == 0)
>>>> +                               udev_selinux_lsetfilecon(udev, file, mode);
>>>
>>> I can't access these bugs.
>>>
>>> Does that makes sense/work for you?
>>>   http://git.kernel.org/?p=linux/hotplug/udev.git;a=commitdiff;h=326c5fc3ea684825629eccaf33a548759162a539
>>>
>>> Kay
>>
>> I ask Harald (but he wasn't around and I don't know the answer) if it is
>> a problem that this changes the behavior of non "add" events.
>> Previously a non "add" event with an incorrect mask/uid/gid would have
>> reset the SELinux context but now it will not.  It fixes the issue at
>> hand, my boxes boot with everything labeled nicely, but I'm not sure if
>> there is some other corner case that expected the old behavior with
>> change events....
> 
> Maybe we should back up and ask the udev folks how they think libvirt
> labeling should be done so as to not conflict with udev labeling, e.g.
> should libvirt be going through udev to assign the labels.
> 
> 
> --
> This message was distributed to subscribers of the selinux mailing list.
> If you no longer wish to subscribe, send mail to majordomo@tycho.nsa.gov with
> the words "unsubscribe selinux" without quotes as the message.
> 
> 
Well I guess I would not want someone chcon a device and then udev
fixing the label.  Especially on MLS machines.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAkx+rQMACgkQrlYvE4MpobPAkQCgt93hFUhnv9wJONN+VN62L5c5
KzYAoKbijORf9iDwDazubFJOmAux/8wY
=BbqG
-----END PGP SIGNATURE-----
