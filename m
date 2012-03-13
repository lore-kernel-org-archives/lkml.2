Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086Ab2CMIyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:54:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165Ab2CMIy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:54:29 -0400
Message-ID: <4F5F0B36.1020808@redhat.com>
Date: Tue, 13 Mar 2012 10:54:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F58664D.1070800@cn.fujitsu.com> <4F58943E.1050402@redhat.com> <4F595B31.9090301@cn.fujitsu.com> <4F5DBC26.7060204@cn.fujitsu.com> <4F5DD0FD.9070904@redhat.com> <4F5EECD9.8050508@cn.fujitsu.com>
In-Reply-To: <4F5EECD9.8050508@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 08:44 AM, Wen Congyang wrote:
> At 03/12/2012 06:33 PM, Avi Kivity Wrote:
> > On 03/12/2012 11:04 AM, Wen Congyang wrote:
> >> Do you have any other comments about this patch?
> >>
> > 
> > Not really, but I'm not 100% convinced the patch is worthwhile.  It's
> > likely to only be used by Linux, which has kexec facilities, and you can
> > put talk to management via virtio-serial and describe the crash in more
> > details than a simple hypercall.
>
> Hmm, can we use virtio-serial to talk with not-linux OS? I guess the answer
> is no. If so, virtio-serial is also used by linux.

You can use virtio-serial with any guest that has a driver.  There are
drivers available for Windows.

> Another problem is: virtio-serial is available on many deployed versions
> but the guest must have virtio-serial device. So we cannot know the guest
> is panicked if it does not have virtio-serial device while the hypercall does
> not depend on any device.
>

The hypercall implementation must exist in the hypervisor.

virtio-serial is used by the guest agent, so it's likely to be
availalble in all cloud or data center deployments.

-- 
error compiling committee.c: too many arguments to function

