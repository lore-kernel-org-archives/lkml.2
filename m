Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab1ATChO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 21:37:14 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40746 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab1ATChM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 21:37:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=t+aFhs1CcyokgMQmLkxKdEdujyRz0RObTdoshSXeF+m3KmvmcAsR76hLtHwAZwMGM3
         Q+YngGj4BkAguLn+BD3993y5YbB83fhLOeQo8W/4s9je+UIaNKhSC2Nk8LRAvSW4rzTN
         G493VAA4HfYeeyAAZL3ncFxbPX5mMTC6V7LYw=
MIME-Version: 1.0
In-Reply-To: <20110119163758.bb43d4ff.akpm@linux-foundation.org>
References: <1294810891-23348-1-git-send-email-vapier@gentoo.org> <20110119163758.bb43d4ff.akpm@linux-foundation.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 19 Jan 2011 21:36:51 -0500
X-Google-Sender-Auth: vsAu1cVw_Wz4vq24iCL3cnI1vCY
Message-ID: <AANLkTinCqNTsy2qo4HHe8pc3=OZ1N3xtEwhXF_PyE3ux@mail.gmail.com>
Subject: Re: [Device-drivers-devel] [PATCH] sigma-firmware: loader for Analog
 Devices' SigmaStudio
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, device-drivers-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 19:37, Andrew Morton wrote:
> On Wed, 12 Jan 2011 00:41:31 -0500 Mike Frysinger wrote:
> The newly-added code has no callsites.  What are we to make of this?

the ASoC drivers have already been submitted and are going through the process

>> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
>> index e8b6a13..8f4f7b2 100644
>> --- a/drivers/firmware/Kconfig
>> +++ b/drivers/firmware/Kconfig
>> @@ -134,4 +134,16 @@ config ISCSI_IBFT
>>         detect iSCSI boot parameters dynamically during system boot, say Y.
>>         Otherwise, say N.
>>
>> +config SIGMA
>> +     tristate "SigmaStudio firmware loader"
>> +     depends on I2C
>
> The dependence on just I2C looks odd.  What's the rationale here?

the code clearly calls i2c_master_send

>> +int process_sigma_actions(struct i2c_client *client, struct sigma_firmware *ssfw)
>
> Global scope appears to be unnecessary.

idea originally was to let people process things more directly, but
there hasnt been a need so far.  so localizing them until someone
needs them is probably fine.

>> +     pr_debug("%s: crc=%x\n", __func__, crc32(0, fw->data, fw->size));
>
> The code calculates and prints the crc but doesn't actually check it
> against anything.  What's up with that?

it's supposed to abort.  guess we forgot to.

>> +static inline u32 sigma_action_len(struct sigma_action *sa)
>> +{
>> +     return (sa->len_hi << 16) | sa->len;
>> +}
>> +
>> +static inline size_t sigma_action_size(struct sigma_action *sa, u32 payload_len)
>> +{
>> +     return sizeof(*sa) + payload_len + (payload_len % 2);
>> +}
>
> Did these two functions need to be in a header?  If they're only ever
> used in sigma.c then they should be located in that file.

part of the original idea of allowing the callers to process things
more directly if necessary.  should be harmless to leave it here.
-mike
