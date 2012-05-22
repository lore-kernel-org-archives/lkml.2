Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab2EVOpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:45:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65534 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487Ab2EVOpC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:45:02 -0400
MIME-Version: 1.0
In-Reply-To: <20120522092552.GB21999@opensource.wolfsonmicro.com>
References: <CAOMZO5A-05jTYpEEPfnJvWpby1YJ1M7=KPn=zahbQrQOgbjR4g@mail.gmail.com>
	<201205221053.21792.marc@cpdesign.com.au>
	<20120522092552.GB21999@opensource.wolfsonmicro.com>
Date: Tue, 22 May 2012 11:45:01 -0300
Message-ID: <CAOMZO5BvQ7gpye53=+egExfzX_hJLN9AiR2QY3cbEiDSb=9XJQ@mail.gmail.com>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
From: Fabio Estevam <festevam@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Marc Reilly <marc@cpdesign.com.au>, Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        =?UTF-8?Q?Philippe_R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 6:25 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, May 22, 2012 at 10:53:21AM +1000, Marc Reilly wrote:
>
>> It was a new format which introduced a padding bit. I wonder if Mark Brown can
>> comment on whether any other devices are using it successfully. (Sorry I can't
>> offer more insights there).
>
> It's only this chip that's doing so.  I'd suggest putting a scope on it
> and having a look at the formatted data.

As I don't have a way to access the SPI pins via scope I did a

git checkout  91b5e7411, which corresponds to the following commit:

commit 91b5e741184ea9836cd7d7509e4f9b6eefa27df2
Author: Marc Reilly <marc@cpdesign.com.au>
Date:   Sun Apr 1 16:41:37 2012 +1000

    mfd: Use regmap for the mc13xxx-core register access

,and now at least it does not silently hang and gives me a regmap failure:

spi_imx imx31-cspi.1: master is unqueued, this is deprecated
mc13xxx spi1.1: Failed to initialize register map: -22
mc13xxx: probe of spi1.1 failed with error -22
