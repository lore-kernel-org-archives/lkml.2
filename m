Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab1CIKA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 05:00:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42944 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757109Ab1CIKA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 05:00:57 -0500
Date: Wed, 9 Mar 2011 10:00:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Cliff Cai <cliffcai.sh@gmail.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>, cliff.cai@analog.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, akpm@linux-foundation.org,
        lrg@slimlogic.co.uk
Subject: Re: [alsa-devel] [Device-drivers-devel] [PATCH] Add driver for
 Analog Devices ADAU1701 SigmaDSP
Message-ID: <20110309100055.GB6923@opensource.wolfsonmicro.com>
References: <1299460302-15392-1-git-send-email-cliff.cai@analog.com>
 <20110307114142.GB13471@opensource.wolfsonmicro.com>
 <AANLkTikynw7vCsqqyNZW-LFuGUKKQEtG3s4YCZjpOvko@mail.gmail.com>
 <20110307121502.GG13471@opensource.wolfsonmicro.com>
 <AANLkTinKpvgBokSHpsVf1KVX+m6sD0Xp_dFe8Y+HzY-7@mail.gmail.com>
 <AANLkTik=wEyCEY5xsrdGJw6t_VHH9ByKt4mX348P8uD7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik=wEyCEY5xsrdGJw6t_VHH9ByKt4mX348P8uD7@mail.gmail.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 03:25:05PM +0800, Cliff Cai wrote:
> On Mon, Mar 7, 2011 at 8:29 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:

> > i dont see the issue here.  the firmware is *optional* and does not
> > impair basic audio output.  further, the firmware is fully
> > written/compiled/maintained by the end customer, just like the
> > application.  which means there is no "magic" here -- the end customer
> > is the wizard.

> it's a DSP,so firmware is not optional,actually there is default
> internal program can be used
> if no external firmware is downloaded,of cause, the internal program
> is only used to test analog audio pass-through.

If there is default firmware then even if it's not particularly useful
the kernel should probably not *require* that additional firmware is
provided during driver startup - the system may wish to wait until later
in the boot to provide it, for example because it needs to mount media
to get to the firmware or because it needs to do additional work to
decide what firmware is required for the current system setup.
