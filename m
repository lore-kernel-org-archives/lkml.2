Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868Ab2CNLE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 07:04:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63671 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755420Ab2CNLE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 07:04:57 -0400
X-IronPort-AV: E=Sophos;i="4.73,583,1325433600"; 
   d="scan'208";a="4533849"
Message-ID: <4F607BCA.5090506@cn.fujitsu.com>
Date: Wed, 14 Mar 2012 19:06:50 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Daniel P. Berrange" <berrange@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Amit Shah <amit.shah@redhat.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F5DD0FD.9070904@redhat.com> <20120313091843.GB3800@redhat.com> <4F5F25BF.7060100@redhat.com> <4F6056FE.3020202@cn.fujitsu.com> <4F6063C8.8010005@redhat.com> <4F606A7C.9090900@cn.fujitsu.com> <20120314103755.GD2708@amit.redhat.com> <4F607857.50402@cn.fujitsu.com> <4F60788A.2070608@redhat.com> <4F6079E7.7010608@cn.fujitsu.com> <20120314105914.GB2315@redhat.com>
In-Reply-To: <20120314105914.GB2315@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-14 19:02:53,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-14 19:02:54,
	Serialize complete at 2012-03-14 19:02:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 03/14/2012 06:59 PM, Daniel P. Berrange Wrote:
> On Wed, Mar 14, 2012 at 06:58:47PM +0800, Wen Congyang wrote:
>> At 03/14/2012 06:52 PM, Avi Kivity Wrote:
>>> On 03/14/2012 12:52 PM, Wen Congyang wrote:
>>>>>
>>>>>> If so, is this channel visible to guest userspace? If the channle is visible to guest
>>>>>> userspace, the program running in userspace may write the same message to the channel.
>>>>>
>>>>> Access control is via permissions.  You can have udev scripts assign
>>>>> whatever uid and gid to the port of your interest.  By default, all
>>>>> ports are only accessible to the root user.
>>>>
>>>> We should also prevent root user writing message to this channel if it is
>>>> used for panicked notification.
>>>>
>>>
>>> Why?  root can easily cause a panic.
>>>
>>
>> root user can write the same message to virtio-serial while the guest is running...
> 
> Unless you are running a MAC policy which strictly confines the root
> account, root can cause a kernel panic regardless of virtio-serial
> permissions in the guest:
> 
>   echo c > /proc/sysrq-trigger

Yes, root user can cause a kernel panic. But if he writes the same message to virtio-serial,
the host will see the guest is panicked while the guest is not panicked. The host is cheated.

If we use vmcall, and the user causes a kernel panic, we can also know the guest is panicked.
It is the thing what we need. We need to know the guest is panicked, and we donot aware
why it is panicked. If the guest is not panicked, and the host think the guest is panicked, it
is not the thing we need.

Thanks

> 
> Regards,
> Daniel

