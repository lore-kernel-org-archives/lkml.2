Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab2LCTXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 14:23:36 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:36086 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab2LCTXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 14:23:34 -0500
Message-ID: <50BCFC34.5030203@wwwdotorg.org>
Date: Mon, 03 Dec 2012 12:23:32 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com> <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de> <50B73710.2040102@nvidia.com> <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de> <50B874C7.5030208@nvidia.com> <20121130103850.GA28367@avionic-0098.adnet.avionic-design.de> <50B9EA76.10803@nvidia.com> <20121201145814.GB18209@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121201145814.GB18209@avionic-0098.adnet.avionic-design.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2012 07:58 AM, Thierry Reding wrote:
> On Sat, Dec 01, 2012 at 01:31:02PM +0200, Terje Bergström wrote:
...
>> I was thinking of definitions like this:
>> 
>> static inline u32 host1x_sync_cfpeek_ctrl_cfpeek_addr_f(u32 v) { 
>> return (v & 0x1ff) << 0; }
>> 
>> versus
>> 
>> #define host1x_sync_cfpeek_ctrl_cfpeek_addr_f(v) ((v) >> 16) &
>> 0x3ff
>> 
>> Both of these produce the same machine code and have same usage,
>> but the latter has type checking and code coverage analysis and
>> the former is (in my eyes) clearer. In both of these cases the
>> usage is like this:
>> 
>> writel(host1x_sync_cfpeek_ctrl_cfpeek_ena_f(1) |
>> host1x_sync_cfpeek_ctrl_cfpeek_channr_f(chid) |
>> host1x_sync_cfpeek_ctrl_cfpeek_addr_f(rd_ptr), m->sync_aperture +
>> host1x_sync_cfpeek_ctrl_r());
> 
> Again there's no precedent for doing this with static inline
> functions. You can do the same with macros. Type checking isn't an
> issue in these cases since we're talking about bitfields for which
> no proper type exists.

I suspect the inline functions could encode signed-vs-unsigned fields,
perhaps catch u8 variables when they should have been u32, etc.?
