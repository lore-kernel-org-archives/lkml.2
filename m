Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab2EKMYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 08:24:24 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:49496 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753418Ab2EKMYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 08:24:22 -0400
Message-ID: <4FAD0327.7040305@ti.com>
Date: Fri, 11 May 2012 15:16:39 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120509 Thunderbird/12.0.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sasha Levin <levinsasha928@gmail.com>, dmitry.torokhov@gmail.com,
        broonie@opensource.wolfsonicro.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TWL6040: fix build error
References: <1336675473-24774-1-git-send-email-levinsasha928@gmail.com> <CAP=VYLqwAO8x4aWw7_pH1LH_SPO9Td2ec9oOmKPL-_5LOEQw3g@mail.gmail.com> <CACxGe6vbn7r10KT-q2GGtJatv12prE4ZFJxWsSzPEyLoCuH27A@mail.gmail.com>
In-Reply-To: <CACxGe6vbn7r10KT-q2GGtJatv12prE4ZFJxWsSzPEyLoCuH27A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 07:27 AM, Grant Likely wrote:
> On Thu, May 10, 2012 at 4:49 PM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
>> On Thu, May 10, 2012 at 2:44 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>>> Fixes build error due to missing of_property_read_u32.
>>
>> Yes, I saw the same on x86-64 allyesconfig -- which means that in addition to
>> this missing header, it needs to have a Kconfig dependency that limits
>> it to just being enabled on the platforms where it physically is possible to
>> have the hardware.  I'm guessing limiting to ARM would be a good start?
> 
> IIRC, this hardware is available on x86.  Also, if CONFIG_OF is not
> set, then the of_property_read_* functions compile out to do-nothing
> stubs.

I had only linux/of_device.h included which would include of.h only if
CONFIG_OF_DEVICE is set.
Since the i386 did not had OF_DEVICE the of.h was not included (by
of_device.h) thus caused a build breakage.

-- 
Péter
