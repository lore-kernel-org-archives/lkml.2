Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab2J3Gpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 02:45:51 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:52908 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab2J3Gpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 02:45:50 -0400
MIME-Version: 1.0
In-Reply-To: <1351540778.2721.7.camel@bwh-desktop.uk.solarflarecom.com>
References: <5afab1ebe83e4361f1fd75bbea0c559af195bf02.1351529738.git.viresh.kumar@linaro.org>
	<1351540778.2721.7.camel@bwh-desktop.uk.solarflarecom.com>
Date: Tue, 30 Oct 2012 12:15:49 +0530
Message-ID: <CAKohponL_3m2KVytiWm8ZHyB5aimk8CzGrqr5J0LMy8MFGodHg@mail.gmail.com>
Subject: Re: [PATCH] net: dsa/slave: Fix compilation warnings
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: davem@davemloft.net, linaro-dev@lists.linaro.org, patches@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 October 2012 01:29, Ben Hutchings <bhutchings@solarflare.com> wrote:
> On Mon, 2012-10-29 at 22:27 +0530, Viresh Kumar wrote:
>> Currently when none of CONFIG_NET_DSA_TAG_DSA, CONFIG_NET_DSA_TAG_EDSA and
>> CONFIG_NET_DSA_TAG_TRAILER is defined, we get following compilation warnings:
>>
>> net/dsa/slave.c:51:12: warning: 'dsa_slave_init' defined but not used [-Wunused-function]
>> net/dsa/slave.c:60:12: warning: 'dsa_slave_open' defined but not used [-Wunused-function]
>> net/dsa/slave.c:98:12: warning: 'dsa_slave_close' defined but not used [-Wunused-function]
>> net/dsa/slave.c:116:13: warning: 'dsa_slave_change_rx_flags' defined but not used [-Wunused-function]
>> net/dsa/slave.c:127:13: warning: 'dsa_slave_set_rx_mode' defined but not used [-Wunused-function]
>> net/dsa/slave.c:136:12: warning: 'dsa_slave_set_mac_address' defined but not used [-Wunused-function]
>> net/dsa/slave.c:164:12: warning: 'dsa_slave_ioctl' defined but not used [-Wunused-function]
>>
>> Fix them by enclosing these routines under #ifdef,endif.
> [...]
>
> This is not a useful configuration.  It might make more sense to make
> NET_DSA a hidden option and have the DSA drivers (in drivers/net/dsa)
> select it rather than depending on it.

I don't have any idea about net/dsa/***. I just wanted to fix this
awkward looking warning :)
What i understood from your comment is: Atleast one of the tagging
formats must be
always enabled if we want to use net/dsa/ stuff ??

And so the functions i have enclosed under ifdefs will always be used
if net/dsa/ is
used.

And so, if we select NET_DSA from these tagging drivers, then only slave.c will
get compiled. Otherwise slave.c dsa.c dsa_core.c wouldn't be compiled and so
no warnings.

Correct??

--
viresh
