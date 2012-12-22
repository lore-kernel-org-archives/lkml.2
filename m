Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab2LVTal (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 14:30:41 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:61671 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2LVTai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 14:30:38 -0500
Message-ID: <50D60A5B.1020700@gmail.com>
Date: Sat, 22 Dec 2012 12:30:35 -0700
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
References: <20121211090910.GA22985@gmail.com> <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com> <50C94A9C.2050900@gmail.com> <CA+55aFxpLJ=gVUSiu04sTzDDrR75B89pzE35MyEyj3pVi5UbiQ@mail.gmail.com> <50C94ECD.6020504@gmail.com> <20121217102000.GE11016@redhat.com>
In-Reply-To: <20121217102000.GE11016@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/12 3:20 AM, Gleb Natapov wrote:
> Does the regression happen because of commit 20b279ddb38c. If it does I
> think it is safe to revert it. KVM disables PEBS during guest entry now, so
> VMs shouldn't be blowing up (they do not in my testing) and if they still
> do we can disable the counter that has PEBS enabled on a guest entry too.
> Yes, if user runs "perf record -e cycles:ppG" he will not know that
> kernel ignored :pp modifier (with 20b279ddb38c he will get an error), but
> at least old binaries will continue working and new binaries can do the
> checking in userspace.
>

Your patch alone was not enough. Start here:
  https://lkml.org/lkml/2012/7/12/3

And from your response:
https://lkml.org/lkml/2012/7/12/337

"Do not run perf kvm. It does not set exclude_guest and :p and :pp is 
not compatible with guest profiling and should be disallowed. Again 
Peter's patch takes care of this."

20b279ddb38c is Peter's patch -- kernel side enforcement that 
exclude_guest needs to be set when using precise mode.

David
