Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab2IQMI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 08:08:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41302 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab2IQMIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 08:08:55 -0400
Message-ID: <50571289.3040509@mvista.com>
Date: Mon, 17 Sep 2012 16:07:37 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 12/24] xen/arm: introduce CONFIG_XEN on ARM
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com> <1347621207-11294-12-git-send-email-stefano.stabellini@eu.citrix.com> <505374E2.5080308@mvista.com> <alpine.DEB.2.02.1209171155010.29232@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1209171155010.29232@kaball.uk.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 17-09-2012 14:57, Stefano Stabellini wrote:

>>> Changes in v2:

>>> - mark Xen guest support on ARM as EXPERIMENTAL.

>>> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>>> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>> ---
>>>   arch/arm/Kconfig |   10 ++++++++++
>>>   1 files changed, 10 insertions(+), 0 deletions(-)

>>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>>> index 2f88d8d..e92518d 100644
>>> --- a/arch/arm/Kconfig
>>> +++ b/arch/arm/Kconfig
>>> @@ -1897,6 +1897,16 @@ config DEPRECATED_PARAM_STRUCT
>>>   	  This was deprecated in 2001 and announced to live on for 5 years.
>>>   	  Some old boot loaders still use this way.
>>>
>>> +config XEN_DOM0
>>> +	def_bool y
>>> +
>>> +config XEN
>>> +	bool "Xen guest support on ARM (EXPERIMENTAL)"
>>> +	depends on EXPERIMENTAL && ARM && OF
>>> +	select XEN_DOM0

>>     What's the point of selecting it if it's always "y"?

> That's because on X86 is not always "y": there are things under
> drivers/xen that compile on both platforms and depend on XEN_DOM0.

    But we're not on x86. On ARM this select is pointless.

WBR, Sergei

