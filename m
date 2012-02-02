Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab2BBUhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:37:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:20109 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab2BBUhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:37:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="103273205"
Message-ID: <4F2AF3F8.3040205@linux.intel.com>
Date: Thu, 02 Feb 2012 12:37:12 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Josh Boyer <jwboyer@redhat.com>, Michal Marek <mmarek@suse.cz>,
        kernel-team@fedoraproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] merge_config.sh: Use the first file as the initial config
References: <20120201170157.GA4907@zod.bos.redhat.com> <1328213697.2342.154.camel@work-vm>
In-Reply-To: <1328213697.2342.154.camel@work-vm>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/02/2012 12:14 PM, John Stultz wrote:
> On Wed, 2012-02-01 at 12:01 -0500, Josh Boyer wrote:
>> Take the first config fragment and use it verbatim as the initial config set.
>> This avoids running the verification loop for the first file, as nothing has
>> actually been merged at this point.  This significantly increases performance
>> for large config fragments.
>>
>> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
>> ---
>>
>> When experimenting with merge_config.sh on the Fedora config fragments, this
>> cut the execution time of a single invocation with all the config fragments
>> in half (from 28 seconds to 13 seconds).
> 
> Adding Darren to the CC.
> 
> Nice! Looks ok to me.
> 
> Acked-by: John Stultz <john.stultz@linaro.org>

Thanks Josh,

Acked-by: Darren Hart <dvhart@linux.intel.com>

> 
>>  scripts/kconfig/merge_config.sh |    6 +++++-
>>  1 files changed, 5 insertions(+), 1 deletions(-)
>>
>> diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_config.sh
>> index ceadf0e..23d738a 100644
>> --- a/scripts/kconfig/merge_config.sh
>> +++ b/scripts/kconfig/merge_config.sh
>> @@ -58,12 +58,16 @@ while true; do
>>  	esac
>>  done
>>
>> -
>> +INITFILE=$1
>> +shift;
>>
>>  MERGE_LIST=$*
>>  SED_CONFIG_EXP="s/^\(# \)\{0,1\}\(CONFIG_[a-zA-Z0-9_]*\)[= ].*/\2/p"
>>  TMP_FILE=$(mktemp ./.tmp.config.XXXXXXXXXX)
>>
>> +echo "Using $INITFILE as base"
>> +cat $INITFILE > $TMP_FILE
>> +
>>  # Merge files, printing warnings on overrided values
>>  for MERGE_FILE in $MERGE_LIST ; do
>>  	echo "Merging $MERGE_FILE"
> 
> 

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
