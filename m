Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab1B1OEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:04:53 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46930 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab1B1OEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:04:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GOBpEww/DnGXQrSv2yGa6KMS3xgy8Z0Pauc+a9myaW7HRtcEYQChJI9kOUcEIitczh
         aboQMH/ZwKnxuhbxvbeIAPaqksiGP9PmyK6t1QXSZS+0FEuYrAn0Q6zPYNKwa3BfTQSV
         oh+uiiHlE1dTpo1eGQWl9fWNREtZOVmfNmrC8=
Date: Mon, 28 Feb 2011 17:04:46 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] power: bq20z75: change to platform driver
Message-ID: <20110228140446.GA28312@oksana.dev.rtsoft.ru>
References: <1298591301-29999-1-git-send-email-rklein@nvidia.com>
 <1298594977.30301.1.camel@rklein-linux2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1298594977.30301.1.camel@rklein-linux2>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 04:49:37PM -0800, Rhyland Klein wrote:
> On Thu, 2011-02-24 at 15:48 -0800, Rhyland Klein wrote:
> > From: Rhyland Klein <rklein@nvidia.com>
> > 
> > This change switches the bq20z75 i2c driver into a platform driver
> > and adds support for an optional battery detect gpio. Now the driver also
> > signals when the battery is inserted or removed.
> > 
> > I also added a retry mechanism so that for boards where there may be
> > intermittent i2c issues, retries can be used to avoid spurious failures.
> > 
> > Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> > ---
[...]
> Anton, are you going to have a chance to review this? I have one more
> patch to submit but I was waiting for this to go in first.

Sorry for the delay.

The main problem with this patch is that it does too many things.
It should be separated into three patches:

1. Convert the driver into a platform driver;
2. Add support for detect gpio;
3. Add retry machanism.

But still, why are you converting the i2c driver into a platform driver?
To pass the GPIOs via platform data? You can do this with I2C driver as
well:

struct i2c_board_info {
        ....
        void            *platform_data;

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
