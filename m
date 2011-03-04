Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057Ab1CDSyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 13:54:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36998 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759900Ab1CDSyB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 13:54:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Unx455GPZhB8RZmw4muBsUHcxNSBfpxhN1kDG7+oLVs2sMNdMtMPLHZX7d7RFWvdB0
         P9XT+5I1kdpK4PwIt9dt/pjrYWatUET7ljolgUeUDQuCg56UFnRyF8/zNlJ224SWBABf
         aiKfReq4hrhXBk3XGrS3z/70R7xtWrQxp/3Vk=
MIME-Version: 1.0
In-Reply-To: <AANLkTinNrOG69Kzy=ZfRjurOedsz2Oazt-FT-m3Ro6Gg@mail.gmail.com>
References: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com> <AANLkTinNrOG69Kzy=ZfRjurOedsz2Oazt-FT-m3Ro6Gg@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 4 Mar 2011 13:53:41 -0500
X-Google-Sender-Auth: WtFxYBzH5mSDu8wvtl-axU24WTo
Message-ID: <AANLkTi=yYOMA-eHnjzQDsLoH6RFtrG6b71HcjUMwjxNV@mail.gmail.com>
Subject: Re: [PATCH v5 00/11] hwmon: (w83627ehf) Add support for NCT6775F and NCT6776F
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>, Ian Dobson <i.dobson@planet-ian.com>,
        Randy Dunlap <rdunlap@xenotime.net>, binximeng@gmail.com,
        lmsensors@tapanitarvainen.fi, andrea.rizzolo@gmail.com,
        jeff.sadowski@gmail.com, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 1:50 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Fri, Mar 4, 2011 at 12:57 PM, Guenter Roeck
> <guenter.roeck@ericsson.com> wrote:
>> The following patch series adds support for NCT6775F and NCT6776F to the
>> w83627ehf driver. It also includes some cleanup and adds support for
>> the fourth temperature sensor on W83677HG-B.
>>
>> No code changes since v4. Resubmitting and widening audience in the hope that
>> someone may find the time to review the changes prior to the next commit window.
>
> I'm not sure my review is worth much, but the driver seems to work.  I've tested
> fan speed measurement, changing pwm2_enable to 1, changing the fan speed,
> and changing back to 5.  Everything looks good.
>
> The only weird thing I noticed is that, the first time I ran sensors, I got:
> fan2:                    0 RPM  (min =    0 RPM, div = 64)
> and thereafter I get
> fan2:                  136 RPM  (min =    0 RPM, div = 64)  ALARM
>
> I suspect (although I haven't checked) that sensors is just reading
> div after it's already changed to 64.

I'll add one more weird thing on my NCT6775F.

[root@midnight w83627ehf.656]# echo 3200 >fan2_min
[root@midnight w83627ehf.656]# cat fan2_div
8
[root@midnight w83627ehf.656]# cat fan2_input
133
[root@midnight w83627ehf.656]# cat fan2_div
16
[root@midnight w83627ehf.656]# cat fan2_input
133
[root@midnight w83627ehf.656]# cat fan2_div
32
[root@midnight w83627ehf.656]# cat fan2_input
133
[root@midnight w83627ehf.656]# cat fan2_div
64
[root@midnight w83627ehf.656]# cat fan2_input
132
[root@midnight w83627ehf.656]# cat fan2_div
64

I waited a second or two between commands.

Does this mean that 16-bit mode works but the driver doesn't realize it works?

--Andy
