Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab2G0PIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 11:08:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49457 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab2G0PIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 11:08:37 -0400
Message-ID: <5012AEEC.4040400@zytor.com>
Date: Fri, 27 Jul 2012 08:08:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Kent Yoder <key@linux.vnet.ibm.com>
CC: James Morris <jmorris@namei.org>, Peter Huewe <peter.huewe@infineon.com>,
        Bryan Freed <bfreed@chromium.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [GIT PULL] New TPM driver and features
References: <20120726143101.GA24237@linux.vnet.ibm.com> <5011BAB1.6060300@zytor.com> <20120727142921.GA28347@linux.vnet.ibm.com>
In-Reply-To: <20120727142921.GA28347@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2012 07:29 AM, Kent Yoder wrote:
> Hi,
>
> On Thu, Jul 26, 2012 at 02:46:25PM -0700, H. Peter Anvin wrote:
>> On 07/26/2012 07:31 AM, Kent Yoder wrote:
>>>        hw_random: add support for the TPM chip as a hardware RNG source
>>
>> Could you clarify this?  rngd (the user of /dev/hw_random) already
>> has support for the TPM... is this fundamentally different (e.g. can
>> it coexist with tcsd being in use at the same time)?
>
>    These can coexist at the same time since /dev/tpm0 is only opened once
> from user-space (from tcsd) and this hwrng driver comes in through the
> kernel. There would be some amount of contention with the tpm, but its
> not likely to be noticable - grabbing rng data doesn't require any state
> in the tpm, like an auth session or key loading.
>
>    Since the rngd support for the tpm requires trousers, this patch will
> be useful in places where you don't want to have to deploy the full TSS,
> like embedded and early boot.
>

Actually the rngd support for the TPM *conflicts* with trousers... I was 
looking at adding trousers support when I stumbled over your patch. 
Your patch is better, because it solves the handover problem (rngd 
should normally be started as early as possible.)

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

