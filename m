Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab2LMXiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 18:38:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40676 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631Ab2LMXis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 18:38:48 -0500
Message-ID: <50CA66F0.50804@zytor.com>
Date: Thu, 13 Dec 2012 15:38:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v6 18/27] x86, boot: add fields to support load bzImage
 and ramdisk above 4G
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org> <1355436141-8668-19-git-send-email-yinghai@kernel.org> <50CA5CAC.9050508@zytor.com> <CAE9FiQXypjnEM60OvZXx8n9LaLexoyeE1zau1bE1YuHN1fmG_w@mail.gmail.com>
In-Reply-To: <CAE9FiQXypjnEM60OvZXx8n9LaLexoyeE1zau1bE1YuHN1fmG_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 03:28 PM, Yinghai Lu wrote:
> On Thu, Dec 13, 2012 at 2:54 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> 0x1f0 is unsuitable for use as sentinel -- or in fact for any purpose --
>> because it is quite plausible that someone may (fairly sanely) start the
>> copy range at 0x1f0 instead of 0x1f1... we really should have documented
>> it that way but it is too late now.
>>
>> However, we can use 0x1ef.
>
> right. updated to use 0x1ef.
>

> +1EF/001	ALL	sentinel	0: states _ext_* fields are valid

Not the correct documentation.  What this does is detect broken 
32/64-bit bootloaders, and the remediation code should zero not just the 
ext_* fields but all the fields that were identified as uninitialized -- 
we're kind of assuming that kexec is representative here, since it 
doesn't help us by giving an ID.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

