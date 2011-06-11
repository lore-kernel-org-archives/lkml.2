Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400Ab1FKAOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 20:14:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:54406 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758302Ab1FKAOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 20:14:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,350,1304319600"; 
   d="scan'208";a="12217581"
From: Andi Kleen <andi@firstfloor.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        linux-kernel@vger.kernel.org, "Huang\, Ying" <ying.huang@intel.com>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 05/10] MCE: Mask out address mask bits below address granuality
References: <4df13c362729376e2@agluck-desktop.sc.intel.com>
	<4DF1D0B1.1020302@jp.fujitsu.com>
	<BANLkTimFXpqLOpX7x-yQ2Sa+aEF4BakSnw@mail.gmail.com>
Date: Fri, 10 Jun 2011 17:12:55 -0700
In-Reply-To: <BANLkTimFXpqLOpX7x-yQ2Sa+aEF4BakSnw@mail.gmail.com> (Tony Luck's
	message of "Fri, 10 Jun 2011 12:06:45 -0700")
Message-ID: <m2ei31ql88.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Luck <tony.luck@gmail.com> writes:

> 2011/6/10 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:
>> Why do you have to mask it out in kernel, why not in user/logger?
>>
>> One possible story is:
>>  "... the brand-new Xeon XXXX has new MCx_***_VALID bit in ****
>>  register, if it is set the lower bits of MCx_ADDR indicates
>>  ****, otherwise the bits are undefined ..."
>>
>> So I think that kernel should convey the raw value from hardware to
>> userland.  Even if it contains some noise on it, user can determine
>> whether it is useful or not.  And more, since this is an error record,
>> there will be no second chance to retrieve the data afterward.
>
> This is a good point - we should log the original untouched bits someplace.

These bits are undefined. It doesn't make sense to log undefined bits.
They can contain random values. Showing random values just confuses
people. 

How would the user even know it's undefined?  They normally don't read
the specs. Really programs have to handle that for the user. And there
the only sane way is to just mask them off.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
