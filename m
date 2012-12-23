Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab2LWXR5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 18:17:57 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:40411 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2LWXRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 18:17:55 -0500
Message-ID: <50D79119.9010002@gmail.com>
Date: Sun, 23 Dec 2012 16:17:45 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf changes for v3.8
References: <20121211090910.GA22985@gmail.com> <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com> <50C94A9C.2050900@gmail.com> <CA+55aFxpLJ=gVUSiu04sTzDDrR75B89pzE35MyEyj3pVi5UbiQ@mail.gmail.com> <50C94ECD.6020504@gmail.com> <20121217102000.GE11016@redhat.com> <50D60A5B.1020700@gmail.com> <20121223092324.GN17584@redhat.com>
In-Reply-To: <20121223092324.GN17584@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/12 2:23 AM, Gleb Natapov wrote:
>> Your patch alone was not enough. Start here:
>>   https://lkml.org/lkml/2012/7/12/3
>>
> I cannot reproduce this failure. I reverted 20b279ddb38c and ran "perf
> record -e cycles:ppG" while guest was running. Admittedly I ran the test
> for a short time, but without disabling PEBS during the guest entry this
> was enough to crash a guest.

In the beginning (without any patches) VMs crashed fairly quickly. With 
your patch it took longer, but I was able to consistently crash VMs. The 
thread notes server info (processor, OS) and VM versions as well as load 
used for the tests -- a cpu bound process (openssl), disk bound (dd) and 
network (netperf).


> What about forcing exclude_guest on an event that
> has precise flag set without reporting error to userspace?

That's up to the perf maintainers -- Ingo, Peter, Arnaldo. Personally, I 
don't like it since kernel side is changing the user request.

David
