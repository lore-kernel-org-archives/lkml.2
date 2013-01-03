Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab3ACGJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 01:09:04 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3954 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3ACGJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 01:09:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 02 Jan 2013 22:06:18 -0800
Message-ID: <50E521AE.2030500@nvidia.com>
Date: Thu, 3 Jan 2013 08:14:06 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lucas Stach <dev@lynxeye.de>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 0/8] Support for Tegra 2D hardware
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com> <1356097818.1490.109.camel@tellur>
In-Reply-To: <1356097818.1490.109.camel@tellur>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.12.2012 15:50, Lucas Stach wrote:
> Am Freitag, den 21.12.2012, 13:39 +0200 schrieb Terje Bergstrom:
>> Some of the issues left open:
>>  * Register definitions still use static inline. There has been a
>>    debate about code style versus ability to use compiler type
>>    checking and code coverage analysis. There was no conclusion, so
>>    I left it as was.
> This has to be resolved before merging. Personally I'm in favour of
> keeping reg access patterns close to what is done in other parts of the
> kernel.

How about if I define inline functions, and #defines to proxy to them?
Something like:

static inline u32 host1x_sync_cfpeek_ctrl_r(void)
{
	return 0x74c;
}
#define HOST1X_SYNC_CFPEEK_CTRL \
	host1x_sync_cfpeek_ctrl_r()

static inline u32 host1x_sync_cfpeek_ctrl_cfpeek_ena_f(u32 v)
{
	return (v & 0x1) << 31;
}
#define HOST1X_SYNC_CFPEEK_CTRL_CFPEEK_ENA_F(v) \
	host1x_sync_cfpeek_ctrl_cfpeek_ena_f(v)

I'd use the macros in .c files. That way the references will look
familiar to reader of .c files, but we can still get the benefits of
compiler processing (type checking, better error codes etc) and gcov
coverage tracking.

Terje
