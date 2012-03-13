Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab2CMGmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:42:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:36741 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab2CMGmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:42:54 -0400
X-IronPort-AV: E=Sophos;i="4.73,575,1325433600"; 
   d="scan'208";a="4521831"
Message-ID: <4F5EECD9.8050508@cn.fujitsu.com>
Date: Tue, 13 Mar 2012 14:44:41 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F58664D.1070800@cn.fujitsu.com> <4F58943E.1050402@redhat.com> <4F595B31.9090301@cn.fujitsu.com> <4F5DBC26.7060204@cn.fujitsu.com> <4F5DD0FD.9070904@redhat.com>
In-Reply-To: <4F5DD0FD.9070904@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-13 14:40:48,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-13 14:40:51,
	Serialize complete at 2012-03-13 14:40:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 03/12/2012 06:33 PM, Avi Kivity Wrote:
> On 03/12/2012 11:04 AM, Wen Congyang wrote:
>> Do you have any other comments about this patch?
>>
> 
> Not really, but I'm not 100% convinced the patch is worthwhile.  It's
> likely to only be used by Linux, which has kexec facilities, and you can
> put talk to management via virtio-serial and describe the crash in more
> details than a simple hypercall.

Hmm, can we use virtio-serial to talk with not-linux OS? I guess the answer
is no. If so, virtio-serial is also used by linux.

Another problem is: virtio-serial is available on many deployed versions
but the guest must have virtio-serial device. So we cannot know the guest
is panicked if it does not have virtio-serial device while the hypercall does
not depend on any device.

Thanks
Wen Congyang
