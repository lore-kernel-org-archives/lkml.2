Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab0HWRxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 13:53:05 -0400
Received: from smtp-out.google.com ([74.125.121.35]:59923 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab0HWRxD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 13:53:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=VbRM8FDs3uIGEx2IRVFjBePvoglappWX+2wB5rXAMGIZzM94rf6XSKaF7MgBzfKci
	3wHOVFlaXTVn6odU7rmDw==
MIME-Version: 1.0
In-Reply-To: <20100821054808.GA29869@localhost>
References: <1282296689-25618-1-git-send-email-mrubin@google.com>
 <1282296689-25618-5-git-send-email-mrubin@google.com> <20100821054808.GA29869@localhost>
From: Michael Rubin <mrubin@google.com>
Date: Mon, 23 Aug 2010 10:52:39 -0700
Message-ID: <AANLkTikS+DUfPz0E2SmCZTQBWL8h2zSsGM8--yqEaVgZ@mail.gmail.com>
Subject: Re: [PATCH 4/4] writeback: Reporting dirty thresholds in /proc/vmstat
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jack@suse.cz" <jack@suse.cz>, "riel@redhat.com" <riel@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 10:48 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Fri, Aug 20, 2010 at 05:31:29PM +0800, Michael Rubin wrote:
>> The kernel already exposes the user desired thresholds in /proc/sys/vm
>> with dirty_background_ratio and background_ratio. But the kernel may
>> alter the number requested without giving the user any indication that
>> is the case.
>>
>> Knowing the actual ratios the kernel is honoring can help app developers
>> understand how their buffered IO will be sent to the disk.
>>
>>       $ grep threshold /proc/vmstat
>>       nr_dirty_threshold 409111
>>       nr_dirty_background_threshold 818223
>
> I realized that the dirty thresholds has already been exported here:
>
> $ grep Thresh  /debug/bdi/8:0/stats
> BdiDirtyThresh:     381000 kB
> DirtyThresh:       1719076 kB
> BackgroundThresh:   859536 kB
>
> So why not use that interface directly?

LOL. I know about these counters. This goes back and forth a lot.
The reason we don't want to use this interface is several fold.

1) It's exporting the implementation of writeback. We are doing bdi
today but one day we may not.
2) We need a non debugfs version since there are many situations where
debugfs requires root to mount and non root users may want this data.
Mounting debugfs all the time is not always an option.
3) Full system counters are easier to handle the juggling of removable
storage where these numbers will appear and disappear due to being
dynamic.

The goal is to get a full view of the system writeback behaviour not a
"kinda got it-oops maybe not" view.

mrubin
