Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab0IMKKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 06:10:14 -0400
Received: from smtp-out.google.com ([74.125.121.35]:34084 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0IMKKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 06:10:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EFPlwAHWidlsNHVRnNg4zZDLcoy/lSAzLIFdMgjB9fdB5z6vTZVUnyusKRbtIr/5cD
         lpB1wjXpnYplO14zL0LQ==
MIME-Version: 1.0
In-Reply-To: <20100913100743.GF5728@lenovo>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
	<1284118900.402.35.camel@laptop>
	<1284125693.402.58.camel@laptop>
	<1284126770.402.60.camel@laptop>
	<20100913085515.GC5728@lenovo>
	<AANLkTi=AceFvNNQmsDYE0MTbOX804P1+mewcr=bAFzXi@mail.gmail.com>
	<20100913100743.GF5728@lenovo>
Date: Mon, 13 Sep 2010 12:10:00 +0200
Message-ID: <AANLkTimLRPe2T7pCo=33MWMjDg1qhAPdSmUA80kYAGrq@mail.gmail.com>
Subject: Re: [PATCH 0/3 v2] nmi perf fixes
From: Stephane Eranian <eranian@google.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        mingo@elte.hu, robert.richter@amd.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, ying.huang@intel.com,
        ming.m.lin@intel.com, yinghai@kernel.org, andi@firstfloor.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 12:07 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Mon, Sep 13, 2010 at 11:54:59AM +0200, Stephane Eranian wrote:
>> Robert,
>>
>> I have able to reproduce very easily on:
>>
>> processor     : 0
>> vendor_id     : AuthenticAMD
>> cpu family    : 16
>> model         : 2
>> model name    : AMD Phenom(tm) 8450 Triple-Core Processor
>> stepping      : 3
>>
>> using:
>>
>> $ perf record -g ./hackbench 10
>> Time: 0.415
>> [ perf record: Woken up 3 times to write data ]
>> [ perf record: Captured and wrote 0.706 MB perf.data (~30841 samples) ]
>> $ dmesg | tail
>> [  418.946001] Uhhuh. NMI received for unknown reason 3d on CPU 0.
>> [  418.946001] Do you have a strange power saving mode enabled?
>> [  418.946001] Dazed and confused, but trying to continue
>>
>> This is with 2.6.36-rc4-tip as of this morning from tip-x86.
>>
>
> Hi Stephane, the hackbench is Ingo's one? I've been using
> http://people.redhat.com/mingo/cfs-scheduler/tools/hackbench.c
>
No, it's one I found via google search:

http://devresources.linuxfoundation.org/craiger/hackbench/
