Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab2KNR6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 12:58:36 -0500
Received: from mail.atsec.com ([195.30.99.214]:42604 "EHLO mail.atsec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab2KNR6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 12:58:34 -0500
Message-ID: <50A3DBC6.6050101@atsec.com>
Date: Wed, 14 Nov 2012 18:58:30 +0100
From: Stephan Mueller <stephan.mueller@atsec.com>
Organization: atsec information security GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Theodore Ts'o" <tytso@mit.edu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: drivers/char/random.c: variable type mismatch
References: <509AFDA6.7070005@atsec.com> <20121108114708.GB5859@thunk.org> <50A3C3A8.4060509@atsec.com> <50A3DA75.60208@zytor.com>
In-Reply-To: <50A3DA75.60208@zytor.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.11.2012 18:52:53, +0100, H. Peter Anvin <hpa@zytor.com> wrote:

Hi Peter,

> On 11/14/2012 08:15 AM, Stephan Mueller wrote:
>>
>> I agree with the argument of correlation.
>>
>> So, if the reduction of values with a known lack of entropy is of
>> interest, why not change the jiffies variable type too? There we know
>> that only the lower 32 bits are really relevant. Therefore, wouldn't be
>> a structure of
>>
>>          struct {
>>                  unsigned jiffies;
>>                  unsigned cycles;
>>                  unsigned num;
>>          } sample;
>>
>> be more appropriate?
>>
> 
> Probably.  It doesn't make much difference, however.

Well, I guess it does. Because for every byte of the struct, the
input_pool is shuffled. Currently, it is shuffled with bytes known to
have no entropy. With the change, the number of bytes mixed into the
pool without entropy is reduced.
> 
>     -hpa
> 

