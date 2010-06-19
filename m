Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab0FSPos (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 11:44:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35407 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab0FSPoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 11:44:46 -0400
Message-ID: <4C1CE5CE.9090807@zytor.com>
Date: Sat, 19 Jun 2010 08:44:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       hpa@linux.intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/build] x86, vdso: Error out if the vdso contains external
 references
References: <tip-*@vger.kernel.org> <tip-05d0b0889ca9d033a960542af7f8a13b3ad4f630@git.kernel.org> <20100619072745.GA18946@basil.fritz.box>
In-Reply-To: <20100619072745.GA18946@basil.fritz.box>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2010 12:27 AM, Andi Kleen wrote:
>> diff --git a/arch/x86/vdso/checkundef.sh b/arch/x86/vdso/checkundef.sh
>> new file mode 100755
>> index 0000000..490be1c
>> --- /dev/null
>> +++ b/arch/x86/vdso/checkundef.sh
>> @@ -0,0 +1,10 @@
>> +#!/bin/sh
>> +nm="$1"
>> +file="$2"
>> +"$nm" "$file" | grep '^ *U' > /dev/null 2>&1
> 
> Does that really handle the failed inline, static function case? 
> 
> In this case you get a function which is not 'U', but it's 
> just in the wrong section. I think that would need to be checked too.
> 

Makes sense.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

