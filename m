Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab2DXIco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 04:32:44 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:60776 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755834Ab2DXIcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 04:32:42 -0400
Message-ID: <4F9664B3.6040104@st.com>
Date: Tue, 24 Apr 2012 14:00:43 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        spear-devel <spear-devel@list.st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "jgarzik@redhat.com" <jgarzik@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2 4/9] ata/sata_mv: Remove conditional compilation of
 clk code
References: <20120424070426.GA24089@lunn.ch> <4F9650B3.9030406@st.com> <20120424072653.GB24089@lunn.ch> <20120424074202.GO24211@n2100.arm.linux.org.uk> <4F965D1C.2010203@st.com> <20120424082652.GQ24211@n2100.arm.linux.org.uk>
In-Reply-To: <20120424082652.GQ24211@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/2012 1:56 PM, Russell King - ARM Linux wrote:
> Think about this case: if you don't have the means to control the clock
> inputs to a device (for example, you don't support the clk API on your
> CPU arch) then for the device to be functional, it must be supplied with
> all its necessary clocks.  Therefore, the clock is already enabled.  It
> makes sense for the clk API to stub-out to be completely transparent and
> non-error inducing to the driver.
> 
> The problem comes with clk_get_rate().  I'd suggest merely returning zero
> for that in this case.  If the clock rate is really required by a driver,
> then the clk API would need to be enabled.

Ok. Will do as suggested. Will include the patches i dropped earlier, where
i removed macros for clk_*().

-- 
viresh
