Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab2DBMG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:06:59 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3116 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab2DBMGz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 08:06:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 02 Apr 2012 05:06:51 -0700
From: Alok Chauhan <alokc@nvidia.com>
To: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        Stephen Warren <swarren@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "bones@secretlab.ca" <bones@secretlab.ca>,
        "ccross@android.com" <ccross@android.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "dgreid@chromium.org" <dgreid@chromium.org>
Date: Mon, 2 Apr 2012 17:36:45 +0530
Subject: RE: [PATCH v2] i2c: tegra: Add delay before reset the controller
Thread-Topic: [PATCH v2] i2c: tegra: Add delay before reset the controller
Thread-Index: Ac0QuhJpleGh3BusTNKEFnrJG9fLFAADjejw
Message-ID: <7A0BFCFE3DA5CD47B0FB7984326F201A136BDCC3DB@BGMAIL01.nvidia.com>
References: <1333345982-16595-1-git-send-email-alokc@nvidia.com>
	<7A0BFCFE3DA5CD47B0FB7984326F201A136BDCC35E@BGMAIL01.nvidia.com>
 <CAM=Q2cuN+qAjDsBNp5Sq_Xs9KGcOQJ+PwjSVW-F0QczxMpWZRQ@mail.gmail.com>
In-Reply-To: <CAM=Q2cuN+qAjDsBNp5Sq_Xs9KGcOQJ+PwjSVW-F0QczxMpWZRQ@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shubhrajyoti,

> Why is it clock cycle dependent?
I think you got me wrong. What I meant to say that delay is calculated based on clock period of that bus. So in this way I don't have to hardcode the delay value.

> Is it possible to poll if the stop is sent by controller ?
No, Tegra i2c controller doesn't have any register for STOP condition completion status bit. So delay is the only option here.

Thanks
Alok

-----Original Message-----
From: Shubhrajyoti Datta [mailto:omaplinuxkernel@gmail.com] 
Sent: Monday, April 02, 2012 3:49 PM
To: Alok Chauhan
Cc: Stephen Warren; linux-kernel@vger.kernel.org; khali@linux-fr.org; ben-linux@fluff.org; w.sang@pengutronix.de; Stephen Warren; olof@lixom.net; bones@secretlab.ca; ccross@android.com; Laxman Dewangan; linux-tegra@vger.kernel.org; linux-i2c@vger.kernel.org; dgreid@chromium.org
Subject: Re: [PATCH v2] i2c: tegra: Add delay before reset the controller

Hi Alok,
Few / doubts /questions.


On Mon, Apr 2, 2012 at 11:29 AM, Alok Chauhan <alokc@nvidia.com> wrote:
> Stephen,
>
> I've updated the commit message and comment in the code as per your suggestion. Tegra I2C controller doesn't have idle bit so delay is required before reset the controller in case of NACK error.  This delay is calculated purely based on clock period of that particular i2c bus and not passed as hardcoded value. I2C SCL clock-stretching won't affect this calculated delay.

Why is it clock cycle dependent?

Is it possible to poll if the stop is sent by controller ?

>
> Thanks
> Alok
>
>
> -----Original Message-----
> From: Alok Chauhan [mailto:alokc@nvidia.com]
> Sent: Monday, April 02, 2012 11:23 AM
> To: swarren@wwwdotorg.org; khali@linux-fr.org; ben-linux@fluff.org; w.sang@pengutronix.de; Stephen Warren; olof@lixom.net; bones@secretlab.ca; omaplinuxkernel@gmail.com; ccross@android.com; Laxman Dewangan; linux-tegra@vger.kernel.org; linux-i2c@vger.kernel.org; dgreid@chromium.org
> Cc: Alok Chauhan; linux-kernel@vger.kernel.org
> Subject: [PATCH v2] i2c: tegra: Add delay before reset the controller
>
> NACK interrupt generated before I2C controller generates the STOP condition on bus. In Software, because of this reset of controller is happening before I2C controller could complete STOP condition. So wait for some time before resetting the controller so that STOP condition has delivered properly on bus.
>
> Added delay of 2 clock period
How did you calculate the 2 clock cycles?


before reset the controller in case of NACK error.
>
> Signed-off-by: Alok Chauhan <alokc@nvidia.com>
> ---
> Added the more descriptive commit message about issue in case of NACK error condition. Changed the comment in code also
>
>  drivers/i2c/busses/i2c-tegra.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>
