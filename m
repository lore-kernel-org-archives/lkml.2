Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab1GYIem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:34:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32834 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab1GYIeg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:34:36 -0400
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=windows-1252
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1311580201.3446.30.camel@lappy>
Date: Mon, 25 Jul 2011 10:34:30 +0200
Cc: Jan Kiszka <jan.kiszka@web.de>, Pekka Enberg <penberg@kernel.org>,
        torvalds@linux-foundation.org, mingo@elte.hu, avi@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, gorcunov@gmail.com, asias.hejun@gmail.com,
        prasadjoshi124@gmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <C56C6EC5-81C6-4880-93BA-E2DA242DCCEF@suse.de>
References: <alpine.DEB.2.00.1107242335580.18045@tiger> <4E2CA6DE.4040900@web.de> <1311580201.3446.30.camel@lappy>
To: Sasha Levin <levinsasha928@gmail.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 25.07.2011, at 09:50, Sasha Levin wrote:

> On Mon, 2011-07-25 at 01:12 +0200, Jan Kiszka wrote:
>> On 2011-07-24 22:37, Pekka Enberg wrote:
>>> Hi Linus,
>>> 
>>> Please consider pulling from
>>> 
>>>  ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git
>>> kvm-tool-for-linus
>>> 
>>> to merge the Native Linux KVM tool to Linux 3.1.
>>> 
>>> [ The changes to 9p headers were already merged but show up in the pull
>>> request. ]
>>> 
>>> The goal of this tool is to provide a clean, from-scratch, lightweight
>>> KVM host
>>> tool implementation that can boot Linux guest images with no BIOS
>>> dependencies
>>> and with only the minimal amount of legacy device emulation. The primary
>>> focus
>>> of the tool is to Linux but there are already people on working on
>>> supporting
>>> GRUB and other operating systems.
>>> 
>>> We want the tool to be part of Linux kernel source tree because we
>>> believe that
>>> ‘perf’ clearly showed the benefits of a single repository for both
>>> kernel and
>>> userspace components. See Ingo Molnar’s email that started the project for
>>> details:
>>> 
>>>  http://thread.gmane.org/gmane.linux.kernel/962051/focus=962620
>> 
>> I've read several times now that developing in a single tree leads to
>> better results. Can you provide some example from the QEMU/KVM projects
>> where the split is preventing innovation, optimizations, or some other
>> kind of progress?
>> 
> 
> Anthony had a talk on last years KVM forum regarding the QEMU threading
> model (slide:
> http://www.linux-kvm.org/wiki/images/7/70/2010-forum-threading-qemu.pdf) .
> 
> It was suggested that the KVM part of QEMU is having a hard time
> achieving the ideal threading model due to its need to support TCG -
> something which has nothing to do with KVM itself.

Sure, but TCG is a really great part of Qemu. And I'm actually one of the few people who believe that in the KVM community ;).

Recently, I sat down for a couple of months and implemented s390x emulation with TCG in Qemu. You know why?

We had KVM support (device emulation, KVM backend) for s390x for more than a year at that point. People constantly broke stuff in the s390x code paths, because they couldn't test it - people seemed to not have too many mainframes lying around at home. With the emulation target, I could make sure that everyone's able to at least compile and run the s390x specific parts and make sure he can do regression testing.

So yes, while TCG is keeping us back in certain areas, it's tremendously useful in others.


Alex

