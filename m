Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab1BZLpV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 06:45:21 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58978 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab1BZLpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 06:45:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=q3kIvW4oPJS8EK1GpjfSj9pAfuQ4tTiPxV+cNowj66/ctToM89RlseO4mt8SSPeA01
         igvSzRLHyYu3nR779A4E+kcALsDVPXRTsa4BvK9KjbcugoiJpMR2X9WAC+Srgg+dszSZ
         I9EfKjhiraRfKlkVTQ8gF4xzTWfKbRQX5WNbs=
Message-ID: <4D68E7CA.60704@gmail.com>
Date: Sat, 26 Feb 2011 12:45:14 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
CC: preining@logic.at,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        "debora@linux.vnet.ibm.com" <debora@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] tpm_tis: Use timeouts returned from TPM
References: <1298403700.25819.7.camel@d941e-10>
In-Reply-To: <1298403700.25819.7.camel@d941e-10>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 08:41 PM, Stefan Berger wrote:
> Below patch applies to the tip of the git tree.
> 
> v2:
>   - adjusting all timeouts for TPM devices reporting too low timeout
> numbers
>   - also displaying in sysfs whether the timeouts are 'original' or
> 'adjusted'
> 
> The current TPM TIS driver in git discards the timeout values returned
> from the TPM. The check of the response packet needs to consider that
> the return_code field is 0 on success and the size of the expected
> packet is equivalent to the header size + u32 length indicator for the
> TPM_GetCapability() result + 3 timeout indicators of type u32.
> 
> Since some TPMs seem to return timeouts in msec rather than usec,
> I am now adjusting all the timeouts rather than just the one for short
> durations.
> 
> I am also adding a sysfs entry 'timeouts' showing the timeouts that are
> being used.

It works:
# dmesg
[15318.813905] tpm_tis 00:0c: 1.2 TPM (device-id 0xB, rev-id 16)
[15318.879154] tpm_tis 00:0c: Adjusting TPM timeout parameters.
# cat /sys/devices/pnp0/00\:0*/timeouts
1000000 2000000 150000000 [adjusted]

thanks,
-- 
js
