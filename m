Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab2G1N6m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 09:58:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45402 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab2G1N6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 09:58:41 -0400
MIME-Version: 1.0
In-Reply-To: <20120727103551.GC14445@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
	<1343149213-10160-13-git-send-email-ming.lei@canonical.com>
	<20120726123655.GE30717@aftab.osrc.amd.com>
	<CACVXFVOvkdCG_cAsCQPuNQB_4BnXq8f=+RnVXH=NS5GNPvQgtg@mail.gmail.com>
	<20120726175421.GB9161@aftab.osrc.amd.com>
	<CACVXFVM5VhaqKRcWu-6Hj_ja4OrEA63udcL_sLoSWtQm4NFNag@mail.gmail.com>
	<20120727103551.GC14445@aftab.osrc.amd.com>
Date: Sat, 28 Jul 2012 21:58:39 +0800
Message-ID: <CACVXFVNT1BFSiTpoOHsx1Uq5wryG7GJ7SAR9qVt2XvNxJe2KvQ@mail.gmail.com>
Subject: Re: [RFC PATCH 12/13] driver core: firmware loader: use small timeout
 for cache device firmware
From: Ming Lei <ming.lei@canonical.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 6:35 PM, Borislav Petkov <bp@amd64.org> wrote:
> On Fri, Jul 27, 2012 at 09:54:25AM +0800, Ming Lei wrote:
>> On Fri, Jul 27, 2012 at 1:54 AM, Borislav Petkov <bp@amd64.org> wrote:
>>
>> >> No, it is not what I was saying.
>>
>> I just mean the point is not mentioned in my commit log, but I admit it should
>> be a appropriate cause.
>>
>> >
>> > Ok, maybe I'm not understanding this then. So explain to me this: why
>> > do you need that timeout value of 10, how did we decide it to be 10
>>
>> If one firmware image was loaded successfully before, the probability of
>> loading it successfully at this time should be much higher than the 1st time
>> because something crazy(for example, the firmware is deleted) happens
>> with low probability.
>
> Believe it or not, I'm addressing exactly the possibility of the
> firmware disappearing from under us in the AMD microcode driver
> currently :) (and some other annoyances, of course).

Of course, it is possible since user can delete it anytime, but with very
low probability.

>
>> Choosing 10 secs is just a estimation for loading time because the maximum
>> size of firmware in current distributions is about 2M bytes, since we know
>> it has been loaded successfully before.
>
> This is exactly the comment we want over the code to explain to others
> why we're choosing 10 secs. Simply add that sentence above the 10s
> assignment and we're perfect! :-)

OK, will add the comments in -v1.

Thanks,
--
Ming Lei
