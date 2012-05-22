Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab2EVAe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 20:34:58 -0400
Received: from szxga01-in.huawei.com ([58.251.152.64]:49659 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab2EVAe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 20:34:57 -0400
Date: Tue, 22 May 2012 08:34:34 +0800
From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] cgroup: fix device deny of DEV_ALL
In-reply-to: <20120521140324.GA5091@sergelap>
X-Originating-IP: [10.166.88.128]
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Amos Kong <akong@redhat.com>, containers@lists.linux-foundation.org,
        mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, tj@kernel.org
Message-id: <4FBADF1A.6040303@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120312
 Thunderbird/11.0
X-CFilter-Loop: Reflected
References: <CAFeW=pZ8Y7ycxjxro7zBMqdtaCOYs4RmoxtDrsN8+mqLhOL--g@mail.gmail.com>
 <20120518081912.16779.21065.stgit@t> <20120521140324.GA5091@sergelap>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn wrote:

> Quoting Amos Kong (akong@redhat.com):
>> @ mount -t cgroup -o devices none /cgroup
>> @ mkdir /cgroups/devices
>> @ ls -l /dev/dm-3
>>  brw-rw----. 1 root disk 253, 3 Oct 14 19:03 /dev/dm-3
>> @ echo 'b 253:3 rw' > devices.deny
>> but I can still write it by 'dd if=/dev/zero of=/dev/dm-3'
>>
>> In devcgroup_create(), we create a new whitelist, and add first
>> entry which type is 'DEV_ALL'. Execute "# echo 'b 253:3 rw' >
>> devices.deny", dev_whitelist_rm() will update access of first
>> entry to 1(m), but type of first entry is still 'DEV_ALL'.
> 
> Hi,
> 
> thanks.  You raise a good point, but I think it needs some discussion.
> 
> What happens right now is that if you have the 'a *:* rwm' entry and do
> echo 'b 253:3 rw' > devices.deny, then when you next cat devices.list you
> will still see the 'a *:* rwm' entry.  So there should be no confusion
> over why the dd succeeds.  You didn't remove the entry, because there
> was no match echoed into devices.deny.


No, you'll see the entry has been changed to 'a *:* m', so I think we
should at least fix this.
