Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab1DFIGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 04:06:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:40545 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab1DFIGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 04:06:52 -0400
Message-ID: <4D9C1F1C.50802@suse.cz>
Date: Wed, 06 Apr 2011 10:06:52 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
Cc: Armin Schindler <armin@melware.de>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 12/34] isdn/diva: Drop __TIME__ usage
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz> <1302015561-21047-13-git-send-email-mmarek@suse.cz>            <alpine.DEB.2.00.1104051709040.7262@justus.melware.de> <20627.1302031056@localhost>
In-Reply-To: <20627.1302031056@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5.4.2011 21:17, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 05 Apr 2011 17:10:34 +0200, Armin Schindler said:
>> On Tue, 5 Apr 2011, Michal Marek wrote:
>>> The kernel already prints its build timestamp during boot, no need to
>>> repeat it in random drivers and produce different object files each
>>> time.
>>
>> The module can be build separately from the kernel, therefore it can have
>> an own build timestamp.
> 
> If the same code is being built as an out-of-tree module, that's a possibly
> good reason for a code version variable, but what does the build timestamp
> actually tell you?  If you already know foo_driver.c version 0.814 was buiilt
> against 2.6.41-rc2, in what cases does it matter if the compile was on Tuesday
> or Thursday - especially since an 'ls -l foo_driver.ko' will tell you?  If it's
> a matter of "the target .config changed on Wednesday", a build timestamp still
> doesn't help over 'ls -l'.

Exactly. Build timestamps are only a poor substitute for proper version
tracking. If you want to be able to reproduce the build of a binary, you
want it to embed some source revision, not the date when you built it.
For the kernel, you can use KBUILD_BUILD_TIMESTAMP=<source timestamp>,
for out-of-tree modules, you need to come up with something own.

Michal
