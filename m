Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab0HaPtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:49:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932429Ab0HaPth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:49:37 -0400
Message-ID: <4C7D248A.2080507@redhat.com>
Date: Tue, 31 Aug 2010 17:49:30 +0200
From: Harald Hoyer <harald@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100624 Fedora/3.1-1.fc14 Thunderbird/3.1
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Daniel J Walsh <dwalsh@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov, greg@kroah.com,
        sds@tycho.nsa.gov
Subject: Re: selinux vs devtmpfs (vs udev)
References: <1282950052.3284.110.camel@dhcp231-106.rdu.redhat.com>	 <AANLkTi=aEdKM_hunJmPzXxPqkrbok+_C6QUKf8v=Q+18@mail.gmail.com>	 <1283210070.3284.139.camel@dhcp231-106.rdu.redhat.com>	 <4C7CC107.1050304@redhat.com> <4C7D0DAD.9030505@redhat.com>	 <4C7D141A.9060102@redhat.com>  <4C7D1868.3090701@redhat.com>	 <1283267765.3284.150.camel@dhcp231-106.rdu.redhat.com>	 <4C7D1E1B.4020700@redhat.com> <1283268367.3284.154.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1283268367.3284.154.camel@dhcp231-106.rdu.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2010 05:26 PM, Eric Paris wrote:
> On Tue, 2010-08-31 at 11:22 -0400, Daniel J Walsh wrote:
>> On 08/31/2010 11:16 AM, Eric Paris wrote:
>
>>> I suggest a third options: Calculate the default at startup and on every
>>> policy load and fix object labels if they are the default.  I'm sure Dan
>>> knows a code example of how to do the calculation.  The pseudocode looks
>>> something like:
>>
>>
>>>
>>> lookup the label on /dev
>>> lookup the label on the initial task
>>> ask the kernel what the resulting label on a file transition with those
>>> two pieces of information will be.
>>
>>
>> NOOOOO
>>
>> libvirt is going in and changing fixed_disk_device_t:s0 to svirt_t:c0,c124
>>
>> We do not want udev to see this and ask what label a device should have
>> if libvirtd_t created a chr_file in device_t.
>
> initial task == /sbin/init
>
> actually I should look if the kernel init_cred (what devtmpfs uses to
> make security decisions) is initrc_t or kernel_t.  I'm guessing it is
> kernel_t but I'm not certain how that gets set.....
>
> -Eric
>

https://bugzilla.redhat.com/show_bug.cgi?id=575128#c14
https://bugzilla.redhat.com/attachment.cgi?id=442223&format=raw

udev/udev-node.c

+			/* set selinux file context on add events */
+			if (strcmp(udev_device_get_action(dev), "add") == 0)
+				udev_selinux_lsetfilecon(udev, file, mode);
