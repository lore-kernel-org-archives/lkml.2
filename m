Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab1AZVlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 16:41:12 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:43349 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753531Ab1AZVlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 16:41:10 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBADMkQE1Ld/sX/2dsb2JhbAAMhAbNY5B2gSODOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,382,1291611600"; 
   d="scan'208";a="89351901"
Message-ID: <4D4094F3.3020607@teksavvy.com>
Date: Wed, 26 Jan 2011 16:41:07 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com> <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net> <4D403855.4050706@teksavvy.com> <4D405A9D.4070607@redhat.com> <4D4076FD.6070207@teksavvy.com> <20110126194127.GE29268@core.coreip.homeip.net> <4D407A46.4080407@teksavvy.com> <20110126195011.GF29268@core.coreip.homeip.net>
In-Reply-To: <20110126195011.GF29268@core.coreip.homeip.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-26 02:50 PM, Dmitry Torokhov wrote:
> On Wed, Jan 26, 2011 at 02:47:18PM -0500, Mark Lord wrote:
>> On 11-01-26 02:41 PM, Dmitry Torokhov wrote:
>>>
>>> I do not consider lsinput refusing to work a regression.
>>
>> Obviously, since you don't use that tool.
>> Those of us who do use it see this as broken userspace compatibility.
>>
>> Who the hell reviews this crap, anyway?
>> Code like that should never have made it upstream in the first place.
>>
> 
> You are more than welcome spend more time on reviews.

Somehow I detect a totally lack of sincerity there.

But thanks for fixing the worst of this regression, at least.

Perhaps you might think about eventually fixing the bad use of -EINVAL
in future revisions.  One way perhaps to approach that, would be to begin
fixing it internally, but still returning the same things from the actual
f_ops->ioctl() routine.

Then eventually provide new ioctl numbers which return the correct -ENOTTY
(or whatever is best there), rather than converting to -EVINAL at the interface.
Then a nice multi-year overlap, with a scheduled removal of the old codes some day.

Then the input subsystem would work more like most other subsystems,
and make userspace programming simpler and easier to "get correct".

Cheers
