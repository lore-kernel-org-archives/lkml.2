Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab2DUT5z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 15:57:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:50448 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab2DUT5x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 15:57:53 -0400
MIME-Version: 1.0
In-Reply-To: <1335011336.3081.12.camel@dabdike.lan>
References: <1334960945.21447.19.camel@ultramagnus.opencreations.com>
	<1335011336.3081.12.camel@dabdike.lan>
Date: Sat, 21 Apr 2012 12:57:50 -0700
Message-ID: <CABE8wwvQ5_4DnOOce8PVcuR=k0RpzcXN5qbNhQ-=+Cq+Zqv6Dg@mail.gmail.com>
Subject: Re: [GIT PULL] libsas fixes for 3.4-rc4
From: Dan Williams <dan.j.williams@intel.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        jack_wang <jack_wang@usish.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 5:28 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2012-04-20 at 15:29 -0700, Dan Williams wrote:
>> These patches, save for the new "scsi: fix eh wakeup (scsi_schedule_eh
>> vs scsi_restart_operations)" and "Revert "[SCSI] libsas: fix sas port
>> naming", were all originally posted before the merge
>> window opened, and have also appeared in -next for the same timeframe.
>>
>> The commit dates are not that aged (9 days old) because they were
>> rebased out of larger set of updates that were pending for 3.4.
>>
>> There is a mix of pure regression fixes and fixes for long-standing bugs
>> in libsas.  Some of the long-standing bug fixes are made worse / easier
>> to trigger by the new async error handling scheme.
>>
>> The largest patch in the series is "libata, libsas: introduce sched_eh
>> and end_eh port ops" it has been on the list since March 10th.
>>
>> Jack Wang has independently tested this set with pm8001 and reports
>> success. [1]
>>
>> Apologies if scsi-rc-fixes was in the process of picking these up.  With
>> -rc4 looming I lost my nerve and pulled the trigger.
>
> Right, so as a point of process, these are SCSI fixes and are supposed
> to be going through the SCSI tree.  The only urgent one is the revert; I
> still have outstanding questions about some of the others.

Up until this feedback I thought the branch was going to be pulled
intact.  So, not trying to subvert process, just thought this request
would be seen as helpful since you seem to have been rather busy of
late.  Yes, I'd much rather these go through the SCSI tree.

> We're at least 3 weeks away from 3.4 (and that's only if -rc6 is final),
> so there's time to address all of this via the usual process.

My concern is that:

 19 files changed, 344 insertions(+), 172 deletions(-)

...is something that should have went in at -rc2.  Waiting longer
likely means cutting down the list even more and either turning it
into something nobody has given serious test time to, or leaving known
bugs un-addressed for 3.4-final.  Some of these we have lived with for
a while, but are worse with the 3.4-rc1 reworked libsas workqueue and
new async error handling changes.  For grey area "is this a pure
regression fix vs old bug that could maybe wait" I thought the earlier
the rc the better.

--
Dan
