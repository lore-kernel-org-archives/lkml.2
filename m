Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239Ab1FXNts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:49:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757731Ab1FXNtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:49:42 -0400
Message-ID: <4E0495F4.7080300@suse.cz>
Date: Fri, 24 Jun 2011 15:49:40 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, "Ted Ts'o" <tytso@mit.edu>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Enable 'make CONFIG_FOO=y oldconfig'
References: <1306707270.2029.377.camel@i7.infradead.org>	<20110530072300.GA9802@elte.hu>	<1306745835.2029.389.camel@i7.infradead.org>	<20110530104231.GF17821@elte.hu>	<20110530104656.GA19532@elte.hu>	<E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>	<20110530105809.GA20133@elte.hu>	<1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>	<alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>	<20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>	<alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>	<1306795186.2029.459.camel@i7.infradead.org>	<BANLkTik=uHr1eX44XV1pAHUfVQ-MorzOnw@mail.gmail.com>	<1306856937.27477.3.camel@i7.infradead.org> <BANLkTi=VoL8ze0AcdkG_QmEH5049X2K6Zw@mail.gmail.com>
In-Reply-To: <BANLkTi=VoL8ze0AcdkG_QmEH5049X2K6Zw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.5.2011 18:12, Arnaud Lacombe wrote:
> Hi,
>
> On Tue, May 31, 2011 at 11:48 AM, David Woodhouse<dwmw2@infradead.org>  wrote:
>> On Mon, 2011-05-30 at 20:24 -0400, Arnaud Lacombe wrote:
>>> It would seem that the underlying symbol is not visible, triggering
>>> the failure of sym_set_tristate_value().
>>
>> Yes, this only lets you set *visible* symbols. If the symbol you're
>> interested in is not visible because some of its dependencies are not
>> set, it doesn't go and automatically enable those.
>>
> As for this choice, it *is* visible. You are missing a call to
> `sym_calc_value()' (actually sym_calc_visibility() but it is not
> exported) before the conditional to correct the visibility.

David, will you post a patch with this fix?

$ make CONFIG_ARCH_OMAP=y ARCH=arm allnoconfig
$ grep CONFIG_ARCH_OMAP .config
# CONFIG_ARCH_OMAP is not set
vs.
$ echo CONFIG_ARCH_OMAP=y >all.config
$ make  ARCH=arm allnoconfig
$ grep CONFIG_ARCH_OMAP .config
CONFIG_ARCH_OMAP=y
...


> Beside that, if the environment is to influence the configuration
> unconditionally, it would rather be better to do that when the Kconfig
> are parsed.

I don't quite understand what you mean here. The environment variables 
are evaluated right after the potential all*.config file is read. Do you 
think there is a problem with that?

Michal
