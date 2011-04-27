Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab1D0F1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 01:27:10 -0400
Received: from m15-14.126.com ([220.181.15.14]:45702 "EHLO m15-14.126.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989Ab1D0F1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 01:27:08 -0400
X-Greylist: delayed 1863 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Apr 2011 01:27:07 EDT
Date: Wed, 27 Apr 2011 12:55:19 +0800 (CST)
From: uabuntsu@live.com
To: "KY Srinivasan" <kys@microsoft.com>
Cc: "Greg KH" <greg@kroah.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>
Message-ID: <232b57ed.60d0.12f954fb649.Coremail.uabuntsu@live.com>
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481DD1C9@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <6E21E5352C11B742B20C142EB499E0481DD1C9@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-8-git-send-email-kys@microsoft.com>
 <20110426224545.GC31974@kroah.com>
Subject: Re:RE: [PATCH 08/25] Staging: hv: vmbus_driver cannot be unloaded;
 cleanup accordingly
MIME-Version: 1.0
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [110.232.35.86]
X-Priority: 3
X-Mailer: Coremail Webmail Server Version SP_ntes V3.5 build
 110215(12912.3637.3636) Copyright (c) 2002-2011 www.mailtech.cn 126com
X-CM-TRANSID: DsqowKALBKe4obdNPNkXAA--.880W
X-CM-SenderInfo: pxde30xwvxqiyswou0bp/1tbi0w8uAkgYxFkvhQAHsQ
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsubscribe linux-kernel
At 2011-04-27 10:31:18£¬"KY Srinivasan" <kys@microsoft.com> wrote:
>
>
>> -----Original Message-----
>> From: Greg KH [mailto:greg@kroah.com]
>> Sent: Tuesday, April 26, 2011 6:46 PM
>> To: KY Srinivasan
>> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
>> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang;
>> Abhishek Kane (Mindtree Consulting PVT LTD)
>> Subject: Re: [PATCH 08/25] Staging: hv: vmbus_driver cannot be unloaded;
>> cleanup accordingly
>> 
>> On Tue, Apr 26, 2011 at 09:20:25AM -0700, K. Y. Srinivasan wrote:
>> > The vmbus driver cannot be unloaded; the windows host does not
>> > permit this. Cleanup accordingly.
>> 
>> Woah, you just prevented this driver from ever being able to be
>> unloaded.
>
>It was never unloadable; while the driver defined an exit routine, 
>there were couple of issues unloading the vmbus driver:
> 
>1) All guest resources given to the host could not be recovered.
>
>2) Windows host would not permit reloading the driver without 
>rebooting the guest.
>
>All I did was acknowledge the current state and cleanup 
>accordingly. This is not unique to Hyper-V; for what it is worth,
>the Xen platform_pci  driver which is equivalent to the vmbus driver
>is also not unlodable (the last time I checked).
>
>> 
>> That's not a "cleanup" that's a major change in how things work.  I'm
>> sure, if you want to continue down this line, there are more things you
>> can remove from the code, right?
>> 
>> What is the real issue here?  What happens if you unload the bus?  What
>> goes wrong?  Can it be fixed?
>
>This needs to be fixed on the host side. I have notified them of the issue. 
>
>> 
>> This is a pretty big commitment...
>
>These drivers only load when Linux is hosted on  a Hyper-V platform;
>I am not sure why it is a "big commitment" given that the host does not 
>permit reloading this driver without rebooting the guest. 
>
>Regards,
>
>K. Y
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>

