Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab1CGVxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:53:13 -0500
Received: from mail.windriver.com ([147.11.1.11]:49010 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526Ab1CGVxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:53:11 -0500
Message-ID: <4D7553C4.7080801@windriver.com>
Date: Mon, 07 Mar 2011 16:53:08 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110127 Thunderbird/3.1.7
MIME-Version: 1.0
To: Nathan Grennan <linux-rt-users@cygnusx-1.org>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] RT for v2.6.34.8 now available.
References: <4D71668F.9050201@windriver.com>	<4D71A88E.2060608@cygnusx-1.org> <AANLkTim3Bwhp4W2zOcAnNxBzz1hmgvPMjtewt1cW8V0s@mail.gmail.com> <4D754FDC.5050701@cygnusx-1.org>
In-Reply-To: <4D754FDC.5050701@cygnusx-1.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2011 21:53:09.0593 (UTC) FILETIME=[0C504C90:01CBDD12]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-03-07 04:36 PM, Nathan Grennan wrote:
> 
>> Yes, it is the header cleanup done in the 33-->34 dev cycle, seen
>> between the rev list ^9e74e7c b66696e that changes slab.h use.
>>
>> If you look at 8a2032dba45e24 *in the patch repo* you will see where
>> I fixed it for the baseline RT-enabled defconfig.  (Meaning I did a
>> make defconfig, then enabled the RT options).  Your config must be
>> setting something different/extra.
>>
>> If you do a git show on the above rev list and on the fix in the patch
>> repo, you will probably be able to tell what is going on.  Also please
>> send me your config (off list) so I can ensure it compiles properly myself.
>>
> 
> I found the cause. The patching was incomplete. The correct patch 
> command is the one below, removing the comment lines.
> 
> cat ../rt-patches/series | grep -v '\#' | xargs -i cat ../rt-patches/{} 
> | patch -p1

Folks should really use git, or quilt, or guilt, or git quilt-import, or
for that matter, *anything* that at least checks exit status.

I like the fact that "git am" is quite strict about what it accepts
and applies, so I'll typically wrap things around that core operation. 

Here is a completely trivial example of using git am:

cat `grep ^[a-zA-Z0-9] series` > /tmp/foo.mbox
git am /tmp/foo.mbox

Paul.


