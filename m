Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab2DXIBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 04:01:09 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:41280 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755477Ab2DXIAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 04:00:54 -0400
Message-ID: <4F965D1C.2010203@st.com>
Date: Tue, 24 Apr 2012 13:28:20 +0530
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
References: <20120424070426.GA24089@lunn.ch> <4F9650B3.9030406@st.com> <20120424072653.GB24089@lunn.ch> <20120424074202.GO24211@n2100.arm.linux.org.uk>
In-Reply-To: <20120424074202.GO24211@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/2012 1:12 PM, Russell King - ARM Linux wrote:
> If you don't have the clk API configured, you have no clocks to control.
> So, why not make clk_get() return NULL, and make the rest of the API
> calls do nothing?  That's what you'll end up codifying in the drivers
> anyway.

Ok. We can return NULL from calls that return clk *. What about other
routines that return integers. Like, clk_enable().

Is returning 0 correct? Which would mean we were able to enable clk, but
actually we haven't.

-- 
viresh
