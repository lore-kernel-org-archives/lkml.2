Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934615Ab1KJNnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:43:40 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35669 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540Ab1KJNni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:43:38 -0500
Message-ID: <4EBBD503.4020308@codemonkey.ws>
Date: Thu, 10 Nov 2011 07:43:31 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain> <4EBB4A21.20707@codemonkey.ws> <alpine.LFD.2.02.1111100829560.1791@tux.localdomain>
In-Reply-To: <alpine.LFD.2.02.1111100829560.1791@tux.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2011 12:46 AM, Pekka Enberg wrote:
> Hi Anthony,
>
>> 1) The RTC emulation is limited to emulating CMOS and only the few fields used
>> to store the date and time. If code is added to arch/x86 that tries to make
>> use of a CMOS field for something useful, kvm-tool is going to fall over.
>>
>> None of the register A/B/C logic is implemented and none of the timer logic is
>> implemented. I imagine this requires kernel command line hackery to keep the
>> kernel from throwing up.
>
> The "fake it until you make it" design principle is actually something Ingo
> suggested early on and has been a really important factor in getting us to where
> we are right now.
>
> Not that I disagree with you. I think we should definitely clean up our hardware
> emulation code.
>
>> If a kernel change that works on bare metal but breaks kvm-tool because
>> kvm-tool is incomplete is committed, is that a regression that requires
>> reverting the change in arch/x86?
>
> If it's the KVM tool being silly, obviously not.
>
>> 2) The qcow2 code is a filesystem implemented in userspace. Image formats are
>> file systems. It really should be reviewed by the filesystem maintainers.
>> There is absolutely no attempt made to synchronize the metadata during write
>> operations which means that you do not have crash consistency of the meta data.
>>
>> If you experience a power failure or kvm-tool crashs, your image will get
>> corrupted. I highly doubt a file system would ever be merged into Linux that
>> was this naive about data integrity.
>
> The QCOW2 is lagging behind because we lost the main developer. It's forced as
> read-only for the issues you mention. If you think it's a merge blocker, we can
> drop it completely from the tree until the issues are sorted out.

It's not just the qcow2 implementation or even the block layer.  This pull 
requests adds a userspace TCP/IP stack to the kernel and yet netdev isn't on the 
CC and there are no Ack's from anyone from the networking stack.  I'm fairly 
sure if they knew what was happening here they would object.

And the implementation isn't even strictly needed.  You can just as well achieve 
the same goal using tun/tap with a privileged helper[1].

>> I found these three issues in the course of about 30 seconds of looking
>> through the kvm-tool code. I'm sure if other people with expertise in these
>> areas looked through the code, they would find a lot more issues. I'm sure I
>> could find many, many more issues.
>
> Thanks for the review!
>
> Would you be interested in spending another 30 seconds to find out some more
> issue? :-)

I could, provided you could take the things you want to do differently and 
submit them as patches to qemu.git instead of creating a new tool.

There are lots of people on qemu-devel than can provide deep review of this type 
of code.  That's the advantage of working in qemu.git.

[1] http://mid.gmane.org/1320086191-23641-1-git-send-email-coreyb@linux.vnet.ibm.com

Regards,

Anthony Liguori
