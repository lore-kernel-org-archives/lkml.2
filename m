Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab2DXMGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 08:06:05 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:55558 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753755Ab2DXMGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 08:06:01 -0400
Message-ID: <4F9696C6.1080404@mvista.com>
Date: Tue, 24 Apr 2012 16:04:22 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@st.com>
CC: Andrew Lunn <andrew@lunn.ch>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
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
References: <20120424070426.GA24089@lunn.ch> <4F9650B3.9030406@st.com>
In-Reply-To: <4F9650B3.9030406@st.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 24-04-2012 11:05, Viresh Kumar wrote:

>> I don't think this change is correct. With the old semantics, it was:

> Sorry. :(

>> If we have CLK support, we expect there to be a clock for sata_mv, and
>> if there is no such clock, output a notice message, something is
>> probably wrong, i expected there to be a clock.

>> The new semantics are:

>> We expect there to be a clock for sata_mv, and if there is no such
>> clock, output a notice message, something is probably wrong, i
>> expected there to be a clock.

>> We are going to see this notice message much more, when it is not
>> expected.

> So, the only problem is this message?
> How do you suggest to tackle this now. Have #ifdef,#endif around this print?

    When there's no CONFIG_HAVE_CLK, if clk_get() returns NULL, not error, 
there'll be no message.

WBR, Sergei
