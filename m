Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030293Ab2EPL3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:29:51 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030281Ab2EPL3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:29:50 -0400
Message-ID: <4FB38FAA.4080603@nod.at>
Date: Wed, 16 May 2012 13:29:46 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com
Subject: Re: [RFC v4] UBI: Fastmap support (aka checkpointing)
References: <1337101871-31181-1-git-send-email-richard@nod.at>  <1337161096.24809.36.camel@sauron.fi.intel.com> <4FB38683.7030306@nod.at>  <1337166556.24809.42.camel@sauron.fi.intel.com> <1337167083.24809.49.camel@sauron.fi.intel.com>
In-Reply-To: <1337167083.24809.49.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.05.2012 13:18, Artem Bityutskiy wrote:
> On Wed, 2012-05-16 at 14:09 +0300, Artem Bityutskiy wrote:
>>> The maximum size of a fastmap is limited to UBI_FM_MAX_BLOCKS.
>>> As I said, in worst case we'd have to scan 192 PEBs, which is a constant.
>>
>> In this case you cannot use O notation at all because it is just used
>> when talking about asymptotic things.
>
> OK, we are talking about different things. It is fine that you need to
> scan 192 eraseblocks, this is kind of your journal. And this part may be
> O(1). But there is another part as well.

Yeah, seems to.

> But as I already explained, you have a _table_ on the flash, and this
> table stores Erase Counter and LEB number for (roughly) each PEB. The
> more PEBs, the large is the table, linerarly.
>
> As I explained, you have to _read_ and _interpret_ each record in this
> table when attaching. And the more of these records you have, the longer
> it takes to attach. And this is where you have your O(N).

Okay, now I understand your point. :)

> So basically fastmap makes UBI's linerar dependency multiplier a lot
> smaller, so it is still a great improvement.

Yep.

Thanks,
//richard

