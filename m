Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab1CKLxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 06:53:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39276 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752016Ab1CKLxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 06:53:50 -0500
Date: Fri, 11 Mar 2011 11:53:44 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Cai, Cliff" <Cliff.Cai@analog.com>
Cc: Cliff Cai <cliffcai.sh@gmail.com>, Mike Frysinger <vapier.adi@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Subject: Re: [alsa-devel] [Device-drivers-devel] [PATCH] Add driver for
 Analog Devices ADAU1701 SigmaDSP
Message-ID: <20110311115344.GA1760@opensource.wolfsonmicro.com>
References: <1299460302-15392-1-git-send-email-cliff.cai@analog.com>
 <20110307114142.GB13471@opensource.wolfsonmicro.com>
 <AANLkTikynw7vCsqqyNZW-LFuGUKKQEtG3s4YCZjpOvko@mail.gmail.com>
 <20110307121502.GG13471@opensource.wolfsonmicro.com>
 <AANLkTinKpvgBokSHpsVf1KVX+m6sD0Xp_dFe8Y+HzY-7@mail.gmail.com>
 <AANLkTik=wEyCEY5xsrdGJw6t_VHH9ByKt4mX348P8uD7@mail.gmail.com>
 <20110309100055.GB6923@opensource.wolfsonmicro.com>
 <DB904C5425BA6F4E8424B3B51A1414D16649F4A546@NWD2CMBX1.ad.analog.com>
 <20110310134605.GC22195@opensource.wolfsonmicro.com>
 <DB904C5425BA6F4E8424B3B51A1414D16649F4A8FB@NWD2CMBX1.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB904C5425BA6F4E8424B3B51A1414D16649F4A8FB@NWD2CMBX1.ad.analog.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 02:54:42AM -0500, Cai, Cliff wrote:

> 1.The default firmware is used when the chip is just powered-up,
> Once driver gets the control,it should load the custom firmware to replace
> The default one,
> 2.we don't need to worry about this case,the driver which needs loading firmware
> Has to be compiled as a module,and of cause,we load it after the filesystem has been mounted.

Forcing the driver to be build modular isn't great for usability either,
though - it's not very general and some systems don't use modules at all
for various reasons (eg, simplicity or difficulties in keeping the fs
and the kernel partitions in sync).

I'm not sure this gels well with the approach you're taking with the
driver just passing the firmware through.  On the one hand you don't
want the driver to know anything about the firmware or join up the
firmware handling with the audio subsystem but on the other hand the
driver is requiring that a firmware be loaded as soon as the driver is
even though it can provide some very basic functionality without it.
It'd seem better to just let the user load firmware at their leisure.
