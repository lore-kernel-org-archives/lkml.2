Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab2DBKTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 06:19:19 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34627 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab2DBKTQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 06:19:16 -0400
MIME-Version: 1.0
In-Reply-To: <7A0BFCFE3DA5CD47B0FB7984326F201A136BDCC35E@BGMAIL01.nvidia.com>
References: <1333345982-16595-1-git-send-email-alokc@nvidia.com>
	<7A0BFCFE3DA5CD47B0FB7984326F201A136BDCC35E@BGMAIL01.nvidia.com>
Date: Mon, 2 Apr 2012 15:49:16 +0530
Message-ID: <CAM=Q2cuN+qAjDsBNp5Sq_Xs9KGcOQJ+PwjSVW-F0QczxMpWZRQ@mail.gmail.com>
Subject: Re: [PATCH v2] i2c: tegra: Add delay before reset the controller
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Alok Chauhan <alokc@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
