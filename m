Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765Ab2CNKaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 06:30:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760447Ab2CNKaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 06:30:17 -0400
Message-ID: <4F607325.6050607@redhat.com>
Date: Wed, 14 Mar 2012 12:29:57 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: "Daniel P. Berrange" <berrange@redhat.com>, kvm list <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F58664D.1070800@cn.fujitsu.com> <4F58943E.1050402@redhat.com> <4F595B31.9090301@cn.fujitsu.com> <4F5DBC26.7060204@cn.fujitsu.com> <4F5DD0FD.9070904@redhat.com> <20120313091843.GB3800@redhat.com> <4F5F25BF.7060100@redhat.com> <4F6056FE.3020202@cn.fujitsu.com> <4F6063C8.8010005@redhat.com> <4F606A7C.9090900@cn.fujitsu.com> <4F606DCC.3020908@redhat.com> <4F60726E.3090807@cn.fujitsu.com>
In-Reply-To: <4F60726E.3090807@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2012 12:26 PM, Wen Congyang wrote:
> >> If so, is this channel visible to guest userspace? If the channle is visible to guest
> >> userspace, the program running in userspace may write the same message to the channel.
> >>
> > 
> > Surely there's some kind of access control on channels.
>
> The virtio-serial depends on more things than touching the hypervisor. So I think touching
> the hypervisor is more reliable than using virtio-serial device, and it is very simple and
> easy to use.
>
> If we pass something from guest userspace to host, we can use virtio-serial. But If we pass
> something from guest kernelspace to host, I still prefer to touch the hypervisor.

There's no argument that it's easier.  My concern is different, we're
adding more and more stuff to the hypervisor because it's easier, which
bloats it.  Every time we do it we add to compatibility and security
problems.

The panic notification is *really* simple, so I don't expect it to cause
a lot of problems.  But still, if it's possible not to change the
hypervisor, we must make an effort in that direction.

-- 
error compiling committee.c: too many arguments to function

