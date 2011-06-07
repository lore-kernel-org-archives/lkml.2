Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab1FGH3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 03:29:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58901 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1FGH3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 03:29:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: viresh kumar <viresh.kumar@st.com>
Subject: Re: [PATCH V2 1/3] drivers/pwm st_pwm: Add support for ST's Pulse Width Modulator
Date: Tue, 7 Jun 2011 09:28:53 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1306831238.git.viresh.kumar@st.com> <20110606173339.268b9f9c.akpm@linux-foundation.org> <4DEDA12D.6080406@st.com>
In-Reply-To: <4DEDA12D.6080406@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106070928.53761.arnd@arndb.de>
X-Provags-ID: V02:K0:F/SmK5GjXHngGllgx97LelfAxuzII6du5n7JoZF4MW/
 JF/+Fp9ur5zZydoPiKsSACeJma0lvYr6EGPc5EpS/MFGTaVDqn
 FQDQNxi1gTUFhkQC7PyxT7iS/VEIwfsdusqbi1g/oqiTGn9myk
 BOZrYUYaDmLlVSzp0JoZq3bR9DSMko08DhNSKmk4JRSnxG4xk+
 UTUjAWVg7vmr2Faj7yF3w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 June 2011 05:55:25 viresh kumar wrote:
> >> +static int __devinit st_pwm_probe(struct platform_device *pdev)
> > 
> > And here things get rather odd.
> > 
> > Most of this file is a generic, non-device specific PWM layer, exported
> > to other modules.  But then we get into driver bits which are specific
> > to one paritular type of device.  Confused - this is like putting the
> > e100 driver inside net/ipv4/tcp.c?
> > 
> 
> Sorry but i couldn't get this one completely. :(
> Driver is specific to pwm peripheral by ST. This driver can be used for
> SPEAr or may be other SoC or Devices, and is not at all dependent on SPEAr.


It was my suggestion to start drivers/pwm/ with this driver. We currently
have a number of pwm drivers spread over the entire tree, all using slight
the same interface header. They all look like this one, and are each used
on one SOC, so you have to choose at compile-time which one to use.

There are two problems with this of course:
1. the drivers that export the same interface should be in one directory
2. there should be a common abstraction layer to avoid duplicate code and
   enable building a kernel with multiple PWM drivers builtin.

Moving this driver to drivers/pwm is the first step to address the
problem 1, we will move the other drivers in the 3.1 or 3.2 timeframe.

There is independent by Sascha Hauer to work on the abstraction layer
for all the drivers. Once that is in, we will change the individual drivers
in drivers/pwm accordingly.

	Arnd
