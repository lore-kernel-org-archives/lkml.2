Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab2GBQyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 12:54:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab2GBQyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 12:54:08 -0400
Message-ID: <4FF1D22D.2070804@redhat.com>
Date: Mon, 02 Jul 2012 11:54:05 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Artem Bityutskiy <dedekind1@gmail.com>,
        Ext4 Mailing List <linux-ext4@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: ext4 blocks up
References: <1341231316.2979.11.camel@sauron.fi.intel.com> <20120702144444.GA18074@thunk.org> <1341240862.2979.23.camel@sauron.fi.intel.com> <20120702151442.GB18074@thunk.org> <20120702164548.GD18074@thunk.org>
In-Reply-To: <20120702164548.GD18074@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 11:45 AM, Theodore Ts'o wrote:
> On Mon, Jul 02, 2012 at 11:14:42AM -0400, Theodore Ts'o wrote:
>> On Mon, Jul 02, 2012 at 05:54:22PM +0300, Artem Bityutskiy wrote:
>>> On Mon, 2012-07-02 at 10:44 -0400, Theodore Ts'o wrote:
>>>> Can you tell me *which* xfstest this was blocking on?
>>>
>>> Test 068 which runs fsstress.
>>
>> Hmmm, I had just started an xfstests -g auto run using standard ext4
>> defaults with 3.5-rc2, and I'm not noting any problems.  And I've
>> gotten past test 68 w/o any problems.
> 
> I just tried again with 3.5-rc5, and I was able to reproduce your
> failure by using "check 68 68 68 68 68" (it failed after the 2nd time
> it ran the fsstress test.  What's interesting is that there have been
> no changes in fs/ext4 or fs/jbd2 since 3.5-rc2.  So this may have been
> caused by a writeback related change; I'm starting a bisect now.

Isn't this just part of the whole class of filesystem freeze races Jan
has been trying to work out?

-Eric
