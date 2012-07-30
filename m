Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab2G3UxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 16:53:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49805 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470Ab2G3UxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 16:53:20 -0400
Message-ID: <5016F429.9030800@zytor.com>
Date: Mon, 30 Jul 2012 13:52:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Kent Yoder <key@linux.vnet.ibm.com>
CC: Kent Yoder <shpedoikal@gmail.com>, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net,
        Peter Huewe <peter.huewe@infineon.com>,
        Bryan Freed <bfreed@chromium.org>,
        David Safford <safford@linux.vnet.ibm.com>
Subject: Re: [GIT PULL] New TPM driver, hwrng driver and fixes
References: <20120727181436.GA6271@linux.vnet.ibm.com> <5012DCF9.7010408@zytor.com> <20120727203000.GA22684@linux.vnet.ibm.com> <5013118D.2030601@zytor.com> <CAM0nabH2629Qx_inhzDuAGggy6rwZJ=rO68yrXie9TtEP6qKuQ@mail.gmail.com> <20120730205116.GA22156@linux.vnet.ibm.com>
In-Reply-To: <20120730205116.GA22156@linux.vnet.ibm.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 01:51 PM, Kent Yoder wrote:
> 
>>> Perhaps we should just do the same "err = total ? total : -EIO;" here
>>> and the above statement can just turn into a break;.
>>
>>   Yeah, this seems like the right thing to do.
>>
>>>> -     ret = my_get_random(hash, SHA1_DIGEST_SIZE);
>>>> +     ret = tpm_get_random(TPM_ANY_NUM, hash, SHA1_DIGEST_SIZE);
>>>>       if (ret < 0)
>>>>               return ret;
>>>
>>> You are still not checking the return values correctly!
>>
>>   Dave, can you weigh in on these individual cases?  In some cases
>> like capping a pcr I think using uninitialized stack data could be
>> better than failing...
> 
> I got in touch with Dave today, who'd like the full checking done now
> that we can. Here's a new patch, let me know what you think...
> 
> Thanks,
> Kent
> 

Looks good to me.

Reviewed-by: H. Peter Anvin <hpa@linux.intel.com>

	-hpa

