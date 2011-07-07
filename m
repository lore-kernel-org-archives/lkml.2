Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab1GGSdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:33:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:42742 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644Ab1GGSdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:33:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,494,1304319600"; 
   d="scan'208";a="22750497"
Message-ID: <4E15FBFE.4090203@linux.intel.com>
Date: Thu, 07 Jul 2011 11:33:34 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: wzt <wzt.wzt@gmail.com>, mingo@redhat.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH] x86: Fix memory leak of init_vdso_vars()
References: <20110705062148.GA6056@program> <20110707131455.GB4078@tiehlicka.suse.cz>
In-Reply-To: <20110707131455.GB4078@tiehlicka.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/7/2011 6:14 AM, Michal Hocko wrote:
> On Tue 05-07-11 14:21:48, wzt wrote:
>> Fix memory leak of init_vdso_vars().
>>
>> Signed-off-by: Zhitong Wang<zhitong.wangzt@alibaba-inc.com>
> The patch looks correct but it could be cleaned up a bit IMO.
> See bellow.

When you run out of memory at early system boot (this is early
system boot only) the system is toast anyways. There's no way
to recover.

I would just add a few GFP_PANICs and then drop the error paths.

-Andi

