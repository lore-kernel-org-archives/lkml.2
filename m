Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0LGBe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 20:34:28 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:59329 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab0LGBe0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 20:34:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DECiYP3GLU0AANp7eIeohE098oFDNZYQw0w6qkGHw21Pe0n4G26Qs1JwvemgQ/h9HZ
         nSHD9WqMr7kppnq6kuuMKitK9ddlEfe/KD1pDLHKpj8YxMZFd5SbQga580x8hbGb2VHO
         iaqXqzRAG1eMLEqbxSrHyR9ATHqn35Fl+oKK8=
MIME-Version: 1.0
In-Reply-To: <5D8008F58939784290FAB48F54975198320B3E4A2D@shsmsx502.ccr.corp.intel.com>
References: <20101201124842.GA5421@intel.com>
	<5D8008F58939784290FAB48F54975198320B3E4A2D@shsmsx502.ccr.corp.intel.com>
Date: Tue, 7 Dec 2010 10:34:25 +0900
X-Google-Sender-Auth: -mXEeN3YgvJXRb5BgOiMvmn2m4k
Message-ID: <AANLkTinrPd9p4ocmE+Krj7t4yV8SMPsDeDFuTByy2=Q4@mail.gmail.com>
Subject: Re: [PATCH v4 0/4]implement eMMC4.4 standard HW reset feature
From: Kyungmin Park <kmpark@infradead.org>
To: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Mai, Leonard" <leonard.mai@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Wolfram Sang <w.sang@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 7, 2010 at 1:03 AM, Dong, Chuanxiao
<chuanxiao.dong@intel.com> wrote:
> Hello all,
> How about these patches? It implemented HW reset feature. When card occurred a timeout error during reading/writing/erasing, these patches will allow driver to reset eMMC card by trigger a HW reset signal.
> Does anyone have any comments about the implementation of these patches? Wolfram and Arnd already pointed out the unsuitable patch headers. Thanks! :)

Hi,
I'm not yet find a reason to use this feature. Now it uses the samsung
and sandisk v4.41 but still no problem.
I wonder what's the purpose and effect if it uses or not?

Thank you,
Kyungmin Park

>
>
>> -----Original Message-----
>> From: linux-mmc-owner@vger.kernel.org
>> [mailto:linux-mmc-owner@vger.kernel.org] On Behalf Of Chuanxiao Dong
>> Sent: Wednesday, December 01, 2010 8:49 PM
>> To: linux-mmc@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org; cjb@laptop.org; arjan@linux.intel.com;
>> alan@linux.intel.com; akpm@linux-foundation.org
>> Subject: [PATCH v4 0/4]implement eMMC4.4 standard HW reset feature
>>
>> Hi,
>>       These are the version 4 patches to implement eMMC4.4 HW reset
>>       feature. Host controller can use this feature by trigger RST_n signal.
>>       To enable this, byte 162 of EXT_CSD register should be set.
>>       HW reset is implemented in mmc core layer and sdhci host layer, and it
>>       will be used after each reading/writing/erasing timeout error occures.
>>
>>       change-log:
>>       This version change the way to detect timeout error conditions. Added a
>>       new routine mmc_handle_timeout_error to do this instead to do this in
>>       mmc_wait_for_req. Each timeout read/write/erase command can use this
>>       routine to do HW reset.
>>
>>       patch1: enable HW reset capability if card support.
>>
>>       patch2: add two new callback to implement HW reset in mmc core layer. In
>>       this patch, routine mmc_handle_timeout_error was added.
>>
>>       patch3: implement hardware_reset callback for sdhci host. A new callback
>>       reset_emmc was defined which will be each sdhci host controller to
>>       implement separately.
>>
>>       patch4: did a HW reset after each read/write/erase command.
>>
>> Thanks
>> Chuanxiao
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
