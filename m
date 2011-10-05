Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935029Ab1JEQmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:42:36 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63590 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934922Ab1JEQmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:42:36 -0400
MIME-Version: 1.0
In-Reply-To: <20111005100244.GA9783@opensource.wolfsonmicro.com>
References: <20111004232403.10364.22050.stgit@ponder> <20111005100244.GA9783@opensource.wolfsonmicro.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 5 Oct 2011 10:42:15 -0600
X-Google-Sender-Auth: YQayc-w9TNE9U7zIjbPZR_byj6I
Message-ID: <CACxGe6sqqjo5wtbmQK_Qfixbj_ZRHBkUFQ7qtxDS53t7qu0EbQ@mail.gmail.com>
Subject: Re: [RFC] drivercore: Add helper macro for platform_driver boilerplate
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 5, 2011 at 4:02 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Oct 04, 2011 at 05:26:55PM -0600, Grant Likely wrote:
>
>> +/* Helper macro for drivers that don't do anything special in module
>> + * init/exit.  This eliminates a lot of boilerplate */
>> +#define module_platform_driver(__platform_driver) \
>> +int __platform_driver##_init(void) \
>> +{ \
>> +     return platform_driver_register(&(__platform_driver)); \
>> +} \
>> +module_init(__platform_driver##_init); \
>
> This looks great but I would prefer it if the function complained if
> something goes wrong - it makes problems a lot more discoverable when
> they crop up.

Yes. As discussed in the other thread, I think that should be added to
the core code, and it can be in a separate patch.  It doesn't belong
in this macro.

g.
