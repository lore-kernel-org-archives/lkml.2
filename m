Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab2DYJ3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 05:29:49 -0400
Received: from londo.lunn.ch ([80.238.139.98]:51371 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757017Ab2DYJ3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 05:29:10 -0400
Date: Wed, 25 Apr 2012 11:31:09 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Lothar Wa??mann <LW@KARO-electronics.de>
Cc: Andrew Lunn <andrew@lunn.ch>, viresh kumar <viresh.linux@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        sshtylyov@mvista.com, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        mturquette@linaro.org, akpm@linux-foundation.org, jgarzik@redhat.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 07/12] ata/sata_mv: Remove conditional compilation of
 clk code
Message-ID: <20120425093109.GC2116@lunn.ch>
Mail-Followup-To: Lothar Wa??mann <LW@KARO-electronics.de>,
	Andrew Lunn <andrew@lunn.ch>, viresh kumar <viresh.linux@gmail.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	sshtylyov@mvista.com, spear-devel@list.st.com,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
	mturquette@linaro.org, akpm@linux-foundation.org,
	jgarzik@redhat.com, linux-arm-kernel@lists.infradead.org
References: <cover.1335266056.git.viresh.kumar@st.com>
 <abbcf661dc58948794839eb0fba1d5a0950ec848.1335266056.git.viresh.kumar@st.com>
 <20120424120019.GE24089@lunn.ch>
 <CAOh2x==YaPxYxigyE=n2weoKHhu4ktGRHHGdzgs2+d1_Lo-D4Q@mail.gmail.com>
 <20120424201802.GE3628@n2100.arm.linux.org.uk>
 <CAOh2x==Se4ipK_jexOE_=82=S4p41W9Ek0Om6DrUwctSz-Wcyw@mail.gmail.com>
 <20120425052802.GF13489@lunn.ch>
 <20375.40225.227084.644318@ipc1.ka-ro>
 <20120425071418.GA2116@lunn.ch>
 <20375.46953.269684.680915@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20375.46953.269684.680915@ipc1.ka-ro>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If an arch has HAVE_CLK enabled it must provide valid clocks (be it
> dummy clocks) for all devices it supports.

So, lets take the theoretical exaple of a unicore32 PUV3

config ARCH_PUV3
        def_bool y
        select CPU_UCV2
        select GENERIC_CLOCKEVENTS
        select HAVE_CLK
        select ARCH_REQUIRE_GPIOLIB
        select ARCH_HAS_CPUFREQ

Seems like this somewhat unknown, to me at least, architecture, also
supports PCI. So i plug in an HP Adaptec AIC8120 SATA host bus adapter
into a spare PCI slot. This uses the Marvell 88SX6041, which the
SATA_MV driver supports.

Should i expect that the unicore32 PUV3 has created a dummy clk for
this case?

Thanks
	Andrew
