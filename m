Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab1I2B5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 21:57:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39157 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab1I2B5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 21:57:43 -0400
Message-ID: <4E83D092.7010405@lwfinger.net>
Date: Wed, 28 Sep 2011 20:57:38 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110907 Thunderbird/6.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: =?UTF-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: =?UTF-8?B?562U5aSNOiDnrZTlpI06IOetlOWkjTogMy4xLXJjNisgcnRsODE=?=
 =?UTF-8?B?OTJzZSBpc3N1ZQ==?=
References: <4E721871.7040901@lwfinger.net> <20110916180323.GA1988@gere.osrc.amd.com> <CD4D8CF16C39438E82FE8241C9AF80F4@realsil.com.cn> <20110921185816.GA2036@gere.osrc.amd.com> <791179BCE62F4954AB936E6CAC9CA977@realsil.com.cn> <4E7AAB8B.40900@lwfinger.net> <20110922075115.GA17640@liondog.tnic> <6452E68488784D0EA32E4BDF1B941EFB@realsil.com.cn> <20110923103339.GA26078@gere.osrc.amd.com> <4E7CB504.4060904@lwfinger.net> <20110928131823.GA2693@gere.osrc.amd.com>
In-Reply-To: <20110928131823.GA2693@gere.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2011 08:18 AM, Borislav Petkov wrote:
> On Fri, Sep 23, 2011 at 11:34:12AM -0500, Larry Finger wrote:
>> On 09/23/2011 05:33 AM, Borislav Petkov wrote:
>>> On Fri, Sep 23, 2011 at 06:21:07PM +0800, 李朝明 wrote:
>>>> Please set ips =0 and try again..
>>>
>>> What does that mean?
>>>
>>> I can trigger the grinding-to-a-halt reliably with "ips=0" - it only
>>> takes a couple of hours of network traffic. Also, I don't want to try
>>> the driver you sent me because the version in the kernel needs fixing
>>> not some out-of-tree codebase.
>>
>> I got a chance to review the rtl8192se part of the changes in that
>> 08/16/2011 version. Attached is a patch to update the kernel
>> version.
>>
>> A prerequisite is:
>>
>> commit da3ba88a9996cd64c6768bed5727e02da81e2c8d
>> Author: Larry Finger<Larry.Finger@lwfinger.net>
>> Date:   Mon Sep 19 14:34:10 2011 -0500
>>
>>      rtlwifi: Combine instances of RTL_HAL_IS_CCK_RATE macros.
>>
>>      Three drivers, rtl8192ce, rtl8192cu and rtl8192de, use the same macro
>>      to check if a particular rate is in the CCK set. This common code is
>>      relocated to a common header file. A distinct macro used by rtl8192se
>>      with the same name is renamed.
>>
>>      Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>>      Signed-off-by: John W. Linville<linville@tuxdriver.com>
>
> Ok, here's what I did.
>
> * merge 'master' branch of
> git://git.infradead.org/users/linville/wireless-next.git with -rc8 in
> order to get da3ba88a9996.
>
> * apply your attached patch with the Realsil facelift:
>
> patching file drivers/net/wireless/rtlwifi/rtl8192se/hw.c
> patching file drivers/net/wireless/rtlwifi/rtl8192se/reg.h
> patching file drivers/net/wireless/rtlwifi/rtl8192se/sw.c
> patching file drivers/net/wireless/rtlwifi/rtl8192se/trx.c
> Hunk #6 FAILED at 540.
> 1 out of 6 hunks FAILED -- saving rejects to file drivers/net/wireless/rtlwifi/rtl8192se/trx.c.rej
> patching file drivers/net/wireless/rtlwifi/wifi.h
> Hunk #1 succeeded at 1328 (offset 3 lines).
>
> (had to apply hunk #6 by hand though)
>
> * build
>
> drivers/net/wireless/rtlwifi/rtl8192se/sw.c:307:8: error: `EFUSE_OOB_PROTECT_BYTES_LEN' undeclared here (not in a function)
> drivers/net/wireless/rtlwifi/rtl8192se/sw.c:307:2: error: array index in initializer not of integer type
> drivers/net/wireless/rtlwifi/rtl8192se/sw.c:307:2: error: (near initialization for `rtl92se_hal_cfg.maps')
> make[5]: *** [drivers/net/wireless/rtlwifi/rtl8192se/sw.o] Error 1
> make[4]: *** [drivers/net/wireless/rtlwifi/rtl8192se] Error 2
> make[3]: *** [drivers/net/wireless/rtlwifi] Error 2
> make[2]: *** [drivers/net/wireless] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
> make: *** Waiting for unfinished jobs....
>
> fix with
>
> diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
> index 615f6b4..55428f2 100644
> --- a/drivers/net/wireless/rtlwifi/wifi.h
> +++ b/drivers/net/wireless/rtlwifi/wifi.h
> @@ -450,6 +450,7 @@ enum rtl_var_map {
>          EFUSE_HWSET_MAX_SIZE,
>          EFUSE_MAX_SECTION_MAP,
>          EFUSE_REAL_CONTENT_SIZE,
> +       EFUSE_OOB_PROTECT_BYTES_LEN,
>
>          /*CAM map */
>          RWCAM,
>
>> I have run the new version for a couple of hours without problems.
>> Perhaps it will cure your difficulty, but I am not optimistic.
>
> Yeah, I'm sorry to confirm that your pessimism turned into realism :-).
> It froze in under 20 mins. Ran the driver with default module parameters
> though.
>
> Looks like I'll have to test the Realsil tarball after all. Question, do
> I simply overwrite the subtree under drivers/net/wireless/rtlwifi/ with
> the files from the tarball?

Asa you probably do not want to kill your standard tree, unpack the Realtek 
version normally, cd to where it unpacked, and do a make. Once it builds, do the 
following:

sudo modprobe -rv rtl8192se
sudo modprobe -v mac80211
sudo insmod rtlwifi.ko
sudo insmod rtl8192se/rtl8192se.ko

>
> Also, any preferred module parameters settings you want me to test?

Try it first with the default parameters. If that fails, use "ips=0".

Larry

