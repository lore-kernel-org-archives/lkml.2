Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab1A0Dbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 22:31:49 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38920 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1A0Dbs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 22:31:48 -0500
MIME-Version: 1.0
In-Reply-To: <lkml-patchwork-507601-use-section@mdm.bga.com>
References: <20110126044406.16410.22096.stgit@localhost6.localdomain6> <lkml-patchwork-507601-use-section@mdm.bga.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 26 Jan 2011 20:31:27 -0700
X-Google-Sender-Auth: UhE0GHHSsrim0ypGE1gib4tu-J0
Message-ID: <AANLkTimssaeQUmvM5BTot23R-hR2PNg3D_barQsGVywi@mail.gmail.com>
Subject: Re: [RFC,1/5] arm/dt: Add dt machine definition
To: Milton Miller <miltonm@bga.com>
Cc: devicetree-discuss@lists.ozlabs.org, jeremy.kerr@canonical.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.orga,
        nicolas.pitre@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 11:27 AM, Milton Miller <miltonm@bga.com> wrote:
> On Wed, 26 Jan 2011 about 04:44:06 -0000, Grant Likely wrote:
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>
> needs a description ...

oops

>>
>> ---
>> arch/arm/include/asm/mach/arch.h |    9 +++++++++
>>  1 files changed, 9 insertions(+), 0 deletions(-)
>>
>>
>>
>> +#define MACH_TYPE_DT 0xffffffff
>> +
>> +#define DT_MACHINE_START(_name, _namestr)            \
>> +static const struct machine_desc __mach_desc_##_name \
>> + __used                                                      \
>> + __attribute__((__section__(".arch.info.init"))) = { \
>
> linux/compiler.h defines __section for this

For commonality, I duplicated what was already done for #define
MACHINE_START in this same file.  However, I'm not even entirely sure
that I'm going to keep this hunk around.  With some of the recent
changes to the arm-dt patches, a special DT machine id of 0xffffffff
is no longer needed.  This patch may get dropped in a future posting
of this series.

g.

>
>> +     .nr             = MACH_TYPE_DT,                 \
>> +     .name           = _namestr,
>> +
>>  #endif
>
> milton
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
