Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2ABRvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 12:51:48 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61079 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab2ABRvr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 12:51:47 -0500
MIME-Version: 1.0
In-Reply-To: <20120102115959.GG2899@opensource.wolfsonmicro.com>
References: <1325483675-21908-1-git-send-email-thomas.abraham@linaro.org>
	<1325483675-21908-2-git-send-email-thomas.abraham@linaro.org>
	<20120102115959.GG2899@opensource.wolfsonmicro.com>
Date: Mon, 2 Jan 2012 23:21:46 +0530
Message-ID: <CAJuYYwQrfp6R=kSzXr6y0unDk9FtNxoy3Lt5QabdNMg9Qux=bg@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/4] lcd: platform-lcd: Eliminate need for platform data
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        kgene.kim@samsung.com, jg1.han@samsung.com, kyungmin.park@samsung.com,
        cbou@mail.ru, kwangwoo.lee@gmail.com, augulis.darius@gmail.com,
        ben-linux@fluff.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 2 January 2012 17:29, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Jan 02, 2012 at 11:24:32AM +0530, Thomas Abraham wrote:
>
>> @@ -10,12 +10,3 @@
>>   * published by the Free Software Foundation.
>>   *
>>  */
>> -
>> -struct plat_lcd_data;
>> -struct fb_info;
>> -
>> -struct plat_lcd_data {
>> -     void    (*set_power)(struct plat_lcd_data *, unsigned int power);
>> -     int     (*match_fb)(struct plat_lcd_data *, struct fb_info *);
>> -};
>
> This is going to break all existing users as it will stop them compiling
> - they'd either need to be converted en masse to the new style as part
> of the commit doing this or the driver would need to support both
> platform data and new style configuration simultaneously.

Yes, it is true that it will break other users and is mentioned it in
the cover letter of this patchset.

Your point on maintaining support for both old and new formats is
helpful. But I am not sure if maintaining support for both formats is
the right thing to do. As most of the ARM platforms will switch to
using dt, maybe converting all of them to new format would be better.
I will try doing this and prepare a patch.

Thanks,
Thomas.
