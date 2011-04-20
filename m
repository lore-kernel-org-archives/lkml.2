Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab1DTRix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 13:38:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39440 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab1DTRiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 13:38:52 -0400
Message-ID: <4DAF1A14.2090703@kernel.org>
Date: Wed, 20 Apr 2011 10:38:28 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 4/4] x86, gart: Make sure GART does not map physmem above
 1TB
References: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com> <1303134346-5805-5-git-send-email-joerg.roedel@amd.com> <4DAC4EC0.80008@zytor.com> <4DAC5099.4010403@kernel.org> <20110418145941.GJ2192@amd.com> <20110418155033.GC8623@elte.hu> <20110419061259.GL2192@amd.com> <20110419072520.GD25353@elte.hu> <4DAD919A.3080102@kernel.org> <20110419142904.GT2192@amd.com>
In-Reply-To: <20110419142904.GT2192@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2011 07:29 AM, Roedel, Joerg wrote:
>>
>> Arguably we call this the k8_nb in other places, so my suggestion would
>> be k8_gart.c
> 
> The k8_nb was renamed to amd_nb recently. The NB is implemented in all
> 64 bit AMD processors and there are more today then K8. The k8_nb was
> historically chosen and misleading today.
> 

OK, fair enough.  However, unless it is actually used in 32-bit mode
calling it amd_gart_64.c is probably better than amd64_gart.c since an
"amd64" processor can also be run in 32-bit mode.

	-hpa
