Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab2G0PI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 11:08:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49460 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab2G0PIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 11:08:54 -0400
Message-ID: <5012AEA4.2030803@zytor.com>
Date: Fri, 27 Jul 2012 08:07:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Kent Yoder <key@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        m.selhorst@sirrix.com, safford@us.ibm.com
Subject: Re: [PATCH 1/2] tpm: Move tpm_get_random api into the TPM device
 driver
References: <1339094567.21398.2.camel@key-ThinkPad-W510> <1339094834.21398.4.camel@key-ThinkPad-W510> <5011C0C3.4090009@zytor.com> <20120727144959.GA22046@linux.vnet.ibm.com>
In-Reply-To: <20120727144959.GA22046@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2012 07:49 AM, Kent Yoder wrote:
>>
>>>   	case Opt_new:
>>> -		ret = my_get_random(payload->key, payload->key_len);
>>> +		ret = tpm_get_random(TPM_ANY_NUM, payload->key,
>>> +				     &payload->key_len);
>>
>> payload->key_len is unsigned int, not size_t; this causes an
>> overwrite of blob_len on 64-bit platforms.
>
>    Good catch.
>

It generated a compiler warning, so that one was trivial to spot.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

