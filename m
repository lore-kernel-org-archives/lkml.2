Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab2KIQBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:01:22 -0500
Received: from outgoing.email.vodafone.de ([139.7.28.128]:39131 "EHLO
	outgoing.email.vodafone.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753522Ab2KIQBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:01:21 -0500
X-Authentication-Info: Sender authenticated as deathsimple@vodafone.de (using CRAM-MD5)
Message-ID: <509D28B6.3060207@vodafone.de>
Date: Fri, 09 Nov 2012 17:00:54 +0100
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-tegra@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 2/2] drm: tegra: Add HDMI support
References: <1352469579-3337-1-git-send-email-thierry.reding@avionic-design.de> <1352469579-3337-3-git-send-email-thierry.reding@avionic-design.de> <CACna6rycZ=TGHP7KpVa_r0JSpc6c=PB89pijR9E_4A=bQ=74Bw@mail.gmail.com>
In-Reply-To: <CACna6rycZ=TGHP7KpVa_r0JSpc6c=PB89pijR9E_4A=bQ=74Bw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.11.2012 16:45, Rafał Miłecki wrote:
> 2012/11/9 Thierry Reding <thierry.reding@avionic-design.de>:
>> +/* all fields little endian */
>> +struct hdmi_audio_infoframe {
>> +       /* PB0 */
>> +       u8 csum;
>> +
>> +       /* PB1 */
>> +       unsigned cc:3; /* channel count */
>> +       unsigned res1:1;
>> +       unsigned ct:4; /* coding type */
>> +
>> +       /* PB2 */
>> +       unsigned ss:2; /* sample size */
>> +       unsigned sf:3; /* sample frequency */
>> +       unsigned res2:3;
>> +
>> +       /* PB3 */
>> +       unsigned cxt:5; /* coding extention type */
>> +       unsigned res3:3;
>> +
>> +       /* PB4 */
>> +       u8 ca; /* channel/speaker allocation */
>> +
>> +       /* PB5 */
>> +       unsigned res5:3;
>> +       unsigned lsv:4; /* level shift value */
>> +       unsigned dm_inh:1; /* downmix inhibit */
>> +
>> +       /* PB6-10 reserved */
>> +       u8 res6;
>> +       u8 res7;
>> +       u8 res8;
>> +       u8 res9;
>> +       u8 res10;
>> +} __packed;
> I was told it won't work on different endian devices. See
> [RFC][PATCH] drm/radeon/hdmi: define struct for AVI infoframe
> http://lists.freedesktop.org/archives/dri-devel/2012-May/022544.html

Yeah, that's indeed true. And honestly adding just another 
implementation of the HDMI info frames sounds like somebody should 
finally sit down and implement it in a common drm_hdmi.c

Regards,
Christian.

