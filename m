Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275Ab2JKU1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:27:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757283Ab2JKU1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:27:42 -0400
Message-ID: <50772BB8.6080404@suse.cz>
Date: Thu, 11 Oct 2012 22:27:36 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Martin Walch <walch.martin@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: Documentation of kconfig language differs from implementation
 regarding existence of symbols
References: <1940598.VZE8PFWQyj@tacticalops>
In-Reply-To: <1940598.VZE8PFWQyj@tacticalops>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 10.10.2012 02:17, Martin Walch napsal(a):
> The file linux/Documentation/kbuild/kconfig-language.txt says:
> 
>> The following two methods produce the same kconfig symbol
>> dependencies but differ greatly in kconfig symbol existence
>> (production) in the generated config file.
>> 
>> case 1:
>> 
>> config FOO tristate "about foo" depends on BAR
>> 
>> vs. case 2:
>> 
>> if BAR config FOO tristate "about foo" endif
>> 
>> In case 1, the symbol FOO will always exist in the config file
>> (given no other dependencies).  In case 2, the symbol FOO will
>> only exist in the config file if BAR is enabled.
> 
> However, I can not reproduce this. The attached file contains both
> cases. When running make menuconfig, setting BAR0 and BAR1 both to
> n, and saving the configuration, there is neither FOO0 nor FOO1 in
> the resulting configuration file.

Indeed, that paragraph seems wrong. I think we should revert commit
64b81ed. Randy, Arnaud?

Thanks,
Michal

