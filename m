Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab1GZNVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 09:21:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab1GZNVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 09:21:41 -0400
Message-ID: <4E2EBF63.8050208@suse.cz>
Date: Tue, 26 Jul 2011 15:21:39 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
Cc: linux-kbuild@vger.kernel.org, lacombar@gmail.com, sam@ravnborg.org,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com
Subject: Re: [RFC][PATCH 1/2] kconfig: Introduce KCONFIG(), KCONFIG_BUILTIN()
 and KCONFIG_MODULE()
References: <4E1D9C25.8080300@suse.cz> <1311634718-32588-1-git-send-email-mmarek@suse.cz> <CAM_iQpUEfYrrtpcRLTekSHMHrTTka6ir=z_GUUbnxuQKfY+OXA@mail.gmail.com>
In-Reply-To: <CAM_iQpUEfYrrtpcRLTekSHMHrTTka6ir=z_GUUbnxuQKfY+OXA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.7.2011 15:01, Américo Wang wrote:
> On Tue, Jul 26, 2011 at 6:58 AM, Michal Marek<mmarek@suse.cz>  wrote:
>> Replace the config_is_*() macros with a variant that allows for grepping
>> for usage of CONFIG_* options in the code. Usage:
>>
>>   if (KCONFIG(CONFIG_NUMA))
>>
>> or
>>
>>   #if KCONFIG(CONFIG_NUMA)
>>
>> The KCONFIG() macro evaluates to 1 if the argument is set (to either 'y'
>> or 'm'), KCONFIG_BUILTIN() and KCONFIG_MODULE() test if the respective
>> option is 'y' and 'm', respectively.
>
> I think it's better to let KCONFIG_MODULE() returns true only for =m, so that
> KCONFIG() will equal to KCONFIG_BUILTIN() || KCONFIG_MODULE().

This is how it's done.


> BTW, the name KCONFIG(CONFIG_NUMA) seems ugly.

Suggest a better one :). The proposals so far:
config_is_numa() (breaks grep)
CONFIGURED(CONFIG_NUMA)
ENABLED(CONFIG_NUMA)
KCONFIG(CONFIG_NUMA)

Michal
