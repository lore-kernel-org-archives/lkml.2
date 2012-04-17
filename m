Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2DQVkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 17:40:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45482 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab2DQVko convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 17:40:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120417183715.GB13989@aftab>
References: <4f660458165dcb73aa4668297a4e32cfb677cff3.1334685628.git.tony.luck@intel.com>
	<20120417183715.GB13989@aftab>
Date: Tue, 17 Apr 2012 14:40:43 -0700
X-Google-Sender-Auth: aDm64EAazEKtbLHgT_3JTZVIVb4
Message-ID: <CA+8MBbK7=PkgfMp3qL4i+Akfg45LaQcEfZa5miYDmk79OCb3jw@mail.gmail.com>
Subject: Re: [PATCH] x86/mce: Avoid reading every machine check bank register twice.
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 11:37 AM, Borislav Petkov <bp@amd64.org> wrote:
> Why, is Waldo hidden somewhere in this patch for us to find?
I leave a couple of easy things for people to nit-pick ... it makes feel
useful when they find stuff to complain about :-)

>> +                     while (++i < banks)
>> +                             __set_bit(i, hintp);
>
> I'm guessing this is there so that whenever we have a serious MCE
> worth of panic, we want to look at the remaining banks no matter their
> validity?
Correct. I didn't want to change the functionality of do_machine_fault()
[even though it doesn't currently handle finding multiple errors very
well - we ought to allow it to see everything]
>
> Why not continue through the banks, filling up the hint bitmap but make
> a note to yourself here that we'll be returning 1 when finished?

That's probably a better idea. We don't gain much by breaking
the loop early - might as well let all the cpus do the full scan of
all the banks in parallel.

>>       DECLARE_BITMAP(toclear, MAX_NR_BANKS);
>> +     DECLARE_BITMAP(hint, MAX_NR_BANKS);
>
> Maybe call it 'toread' like the toclear above so that we know what it
> means? Or even better, valid_banks or something...?

See - you found Waldo (I suck at choosing good names). valid_banks
has a good sound to it.

Thanks - I will respin a v2 soon.

-Tony
