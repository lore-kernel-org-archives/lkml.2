Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422965Ab2KNQPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:15:41 -0500
Received: from mail.atsec.com ([195.30.99.214]:40089 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422677Ab2KNQPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:15:40 -0500
Message-ID: <50A3C3A8.4060509@atsec.com>
Date: Wed, 14 Nov 2012 17:15:36 +0100
From: Stephan Mueller <stephan.mueller@atsec.com>
Organization: atsec information security GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: drivers/char/random.c: variable type mismatch
References: <509AFDA6.7070005@atsec.com> <20121108114708.GB5859@thunk.org>
In-Reply-To: <20121108114708.GB5859@thunk.org>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.11.2012 12:47:08, +0100, Theodore Ts'o <tytso@mit.edu> wrote:

Hi Theodore,

> On Thu, Nov 08, 2012 at 01:32:38AM +0100, Stephan Mueller wrote:
>>
>> However, due to the fact that jiffies provides very few entropy, the
>> event value provides (almost) none, the majority of entropy comes from
>> the processor cycles. Assuming that the processor cycles increase once
>> per nanosecond, after 2**32 cycles (about 4 seconds), the counter wraps.
> 
> Sure, we can make this change, but it doesn't make as much difference
> as you think.  The high 32 bits gets incremented about ounce every 4
> seconds, while jiffies gets incremented once every 1/HZ seconds.  But
> the point is they are pretty well correlated (i.e., if you know the
> jiffies values A' and A'', and I know the high 32 bits of the cycles
> B', and you can determine the likely value of B'' to a very high
> degree of accuracy.  Values which are correlated don't actually
> entropy.
> 

I agree with the argument of correlation.

So, if the reduction of values with a known lack of entropy is of
interest, why not change the jiffies variable type too? There we know
that only the lower 32 bits are really relevant. Therefore, wouldn't be
a structure of

        struct {
                unsigned jiffies;
                unsigned cycles;
                unsigned num;
        } sample;

be more appropriate?

Thanks
Stephan

