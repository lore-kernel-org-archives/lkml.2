Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab2B2KaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 05:30:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54241 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab2B2KaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 05:30:16 -0500
Message-ID: <4F4DFE7C.3030501@cn.fujitsu.com>
Date: Wed, 29 Feb 2012 18:31:24 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "Daniel P. Berrange" <berrange@redhat.com>, kvm list <kvm@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [PATCH] kvm: notify host when guest paniced
References: <4F4AF1FB.6000903@cn.fujitsu.com> <4F4CB926.6050600@redhat.com> <4F4D7F5E.5040202@cn.fujitsu.com> <4F4DF4C6.90609@redhat.com> <20120229095842.GF5050@redhat.com> <4F4DF86C.5010407@redhat.com>
In-Reply-To: <4F4DF86C.5010407@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-29 18:28:24,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-29 18:28:26,
	Serialize complete at 2012-02-29 18:28:26
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 02/29/2012 06:05 PM, Avi Kivity Wrote:
> On 02/29/2012 11:58 AM, Daniel P. Berrange wrote:
>>>
>>> How about using a virtio-serial channel for this?  You can transfer any
>>> amount of information (including the dump itself).
>>
>> When the guest OS has crashed, any dumps will be done from the host
>> OS using libvirt's core dump mechanism. The guest OS isn't involved
>> and is likely too dead to be of any use anyway. Likewise it is
>> quite probably too dead to work a virtio-serial channel or any
>> similarly complex device. We're really just after the simplest
>> possible notification that the guest kernel has paniced.
> 
> If it's alive enough to panic, it's alive enough to kexec its kdump
> kernel.  After that it can do anything.
> 
> Guest-internal dumps are more useful IMO that host-initiated dumps.  In

Yes, guest-internal dump is better than host dump. But the user may not
start guest-internal dump or guest-internal dump failed. So we need the
following feature:
1. If the guest-internal dump does not work, the guest's status is 'crashed'.
   And then the user does the host dump.
2. If the guest-internal dump is working, the guest's status should be
   'dumping'. The user see this status and know the guest has paniced, and
    the guest-internal dump is working.

Thanks
Wen Congyang

> a cloud, the host-initiated dump is left on the host, outside the reach
> of the guest admin, outside the guest image where all the symbols are,
> and sometimes not even on the same host if a live migration occurred. 
> It's more useful in small setups, or if the problem is in the
> hypervisor, not the guest.
> 

