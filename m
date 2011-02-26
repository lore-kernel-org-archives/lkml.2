Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab1BZODt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 09:03:49 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54137 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab1BZODs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 09:03:48 -0500
Message-ID: <4D690842.6090706@linux.vnet.ibm.com>
Date: Sat, 26 Feb 2011 09:03:46 -0500
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: preining@logic.at,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        "debora@linux.vnet.ibm.com" <debora@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] tpm_tis: Use timeouts returned from TPM
References: <1298403700.25819.7.camel@d941e-10> <4D68E7CA.60704@gmail.com> <4D6904CB.9020309@linux.vnet.ibm.com> <4D6904F9.7080604@gmail.com>
In-Reply-To: <4D6904F9.7080604@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2011 08:49 AM, Jiri Slaby wrote:
> On 02/26/2011 02:48 PM, Stefan Berger wrote:
>> On 02/26/2011 06:45 AM, Jiri Slaby wrote:
>>> On 02/22/2011 08:41 PM, Stefan Berger wrote:
>>>> Below patch applies to the tip of the git tree.
>>>>
>>>> v2:
>>>>     - adjusting all timeouts for TPM devices reporting too low timeout
>>>> numbers
>>>>     - also displaying in sysfs whether the timeouts are 'original' or
>>>> 'adjusted'
>>>>
>>>> The current TPM TIS driver in git discards the timeout values returned
>>>> from the TPM. The check of the response packet needs to consider that
>>>> the return_code field is 0 on success and the size of the expected
>>>> packet is equivalent to the header size + u32 length indicator for the
>>>> TPM_GetCapability() result + 3 timeout indicators of type u32.
>>>>
>>>> Since some TPMs seem to return timeouts in msec rather than usec,
>>>> I am now adjusting all the timeouts rather than just the one for short
>>>> durations.
>>>>
>>>> I am also adding a sysfs entry 'timeouts' showing the timeouts that are
>>>> being used.
>>> It works:
>> 'It' means also 'suspend' works?
> Yes.
>
That's great! Thanks for testing the patch!

    Stefan

> regards,

