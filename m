Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab1HBOol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 10:44:41 -0400
Received: from mx2.parallels.com ([64.131.90.16]:50132 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816Ab1HBOoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 10:44:34 -0400
Message-ID: <4E380D19.7030307@parallels.com>
Date: Tue, 2 Aug 2011 11:43:37 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Dave Chinner <david@fromorbit.com>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>,
        <containers@lists.linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [PATCH 4/4] parse options in the vfs level
References: <1311947059-17209-1-git-send-email-glommer@parallels.com> <1311947059-17209-5-git-send-email-glommer@parallels.com> <20110731013456.GM5404@dastard> <4E37F5C6.8060908@parallels.com> <20110802141806.GL2203@ZenIV.linux.org.uk>
In-Reply-To: <20110802141806.GL2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.106.54.7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2011 11:18 AM, Al Viro wrote:
> On Tue, Aug 02, 2011 at 10:04:06AM -0300, Glauber Costa wrote:
>
>> I am not sure either, but I still believe my proposal is superior to
>> write-to-a-file specifically. Writing to a file, be it in proc, sys,
>> or wherever, leaves a window of opportunity open between mounting a
>> filesystem and limiting its caches. Doing it on mount is atomic.
>>
>> Effectively, I see this limit as a property of a particular instance
>> of a mounted filesystem. Since all properties of a filesystem are
>> specified during mount, this becomes a natural extension.
>
> The trouble is, dentry tree is fundamentally a property of superblock.
> It's shared between *all* instances of that fs in all mount trees...

And how is it different from any fs-specific options, like the ones extX 
have, for instance ? Many of them seem to operate on a superblock.

If you mount a superblock somewhere, you can tweak specifics about its 
operation. If you mount it somewhere else, the assumption is you know 
what you're doing.


