Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab1FOWHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 18:07:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab1FOWHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 18:07:13 -0400
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4DF92C80.3030106@codemonkey.ws>
Date: Thu, 16 Jun 2011 00:07:09 +0200
Cc: Prasad Joshi <prasadjoshi124@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <7A30A509-47AA-4E72-ABF3-937005900F9D@suse.de>
References: <1308153214.7566.6.camel@jaguar>	<4DF8DE26.1070301@redhat.com>	<BANLkTi=SHENDBHdtFY_7_qtfqJb_+qKJSw@mail.gmail.com> <BANLkTinMDz-sqaX0cyWEoLXt70dowxofvg@mail.gmail.com> <4DF92C80.3030106@codemonkey.ws>
To: Anthony Liguori <anthony@codemonkey.ws>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 16.06.2011, at 00:04, Anthony Liguori wrote:

> On 06/15/2011 03:13 PM, Prasad Joshi wrote:
>> On Wed, Jun 15, 2011 at 6:10 PM, Pekka Enberg<penberg@kernel.org>  wrote:
>>> On Wed, Jun 15, 2011 at 7:30 PM, Avi Kivity<avi@redhat.com>  wrote:
>>>> On 06/15/2011 06:53 PM, Pekka Enberg wrote:
>>>>> 
>>>>> - Fast QCOW2 image read-write support beating Qemu in fio benchmarks. See
>>>>> the
>>>>>   following URL for test result details: https://gist.github.com/1026888
>>>> 
>>>> This is surprising.  How is qemu invoked?
>>> 
>>> Prasad will have the details. Please note that the above are with Qemu
>>> defaults which doesn't use virtio. The results with virtio are little
>>> better but still in favor of tools/kvm.
>>> 
>> 
>> The qcow2 image used for testing was copied on to /dev/shm to avoid
>> the disk delays in performance measurement.
>> 
>> QEMU was invoked with following parameters
>> 
>> $ qemu-system-x86_64 -hda<disk image on hard disk>  -hdb
>> /dev/shm/test.qcow2 -m 1024M
> 
> Looking more closely at native KVM tools, you would need to use the following invocation to have an apples-to-apples comparison:
> 
> qemu-system-x86_64 -drive file=/dev/shm/test.qcow2,cache=writeback,if=virtio

Wouldn't this still be using threaded AIO mode? I thought KVM tools used native AIO?


Alex

