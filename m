Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630Ab1IOGnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 02:43:39 -0400
Received: from mail.ss.pku.edu.cn ([211.101.48.138]:43987 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab1IOGni convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 02:43:38 -0400
MIME-Version: 1.0
In-Reply-To: <ee48c89a-1e72-4b35-b9fc-99f4b8ade483@glegroupsg2000goo.googlegroups.com>
References: <fa.FZDTDqnxL4JfQvyaCQTn405rzwM@ifi.uio.no>
	<ee48c89a-1e72-4b35-b9fc-99f4b8ade483@glegroupsg2000goo.googlegroups.com>
Date: Thu, 15 Sep 2011 14:43:32 +0800
Message-ID: <CAF1ivSY7rHuA_SGpnPkQ2hLwwOTEtDFTn=e_vx1=C_kW3aDjRA@mail.gmail.com>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.3)
From: Lin Ming <mlin@ss.pku.edu.cn>
To: fa.linux.kernel@googlegroups.com, slawomir.czarko@gmail.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Sattler <tsattler@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 8:57 PM, Slawomir Czarko-Wasiutycz
<slawomir.czarko@gmail.com> wrote:
> On Thursday, April 21, 2011 1:28:18 AM UTC+2, Thomas Sattler wrote:
>> Hi there ...
>>
>> While running firefox (>50 open Tabs), khugepaged jumped to 99.99%
>> (according to 'iotop').  I killed firefox and nearly all running
>> programs but khugepaged was still at 99.99% IO while the system
>> was almost idle. I waited about 10 minutes, no improvement, so
>> I rebooted the machine.
>>
> Hi,
>
> I have a similar problem.
>
> System becomes unresponsive for few seconds up to a minute or so.
>
> In my case the trigger seems to be compiling code in a Linux VM running in VMplayer.
>
> Problem seems to go away if I do:
>
> echo madvise > /sys/kernel/mm/transparent_hugepage/defrag
>
> Kernel used: kernel-PAE-2.6.40.4-5.fc15.i686 SMP CONFIG_PREEMPT=n

(Add Thomas and Andrea)

Hi, Thomas

Do you still see this problem on latest kernel(2.6.31-rc6)?
I try to run firefox (>50 open Tabs), but can't reproduce this on
2.6.31-rc6 kernel.

# cat /proc/`pgrep khugepaged`/io
rchar: 0
wchar: 0
syscr: 0
syscw: 0
read_bytes: 0
write_bytes: 0
cancelled_write_bytes: 0

Andrea,

>From above output, all fields are zero.
Does it mean that transparent huge page was not triggered/used at all?

Regards,
Lin Ming
