Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab1CWDQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 23:16:46 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58015 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab1CWDQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 23:16:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6293"; a="81302642"
Message-ID: <4D896616.7070307@codeaurora.org>
Date: Tue, 22 Mar 2011 20:16:38 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
CC: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        "'Arnd Bergmann'" <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Use asm-generic/sizes.h
References: <1300751462-1494-1-git-send-email-sboyd@codeaurora.org>	<201103220934.50435.arnd@arndb.de>	<20110322092113.GB17264@n2100.arm.linux.org.uk>	<201103221110.20861.arnd@arndb.de>	<00ec01cbe897$2eed7210$8cc85630$@mprc.pku.edu.cn>	<4D88ECE3.1070209@codeaurora.org> <00fc01cbe8f9$cd807640$688162c0$@mprc.pku.edu.cn>
In-Reply-To: <00fc01cbe8f9$cd807640$688162c0$@mprc.pku.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2011 06:29 PM, Guan Xuetao wrote:
>> -----Original Message-----
>> From: Stephen Boyd [mailto:sboyd@codeaurora.org]
>> Sent: Wednesday, March 23, 2011 2:40 AM
>> To: Guan Xuetao
>> Cc: 'Arnd Bergmann'; linux-arm-kernel@lists.infradead.org; 'Russell King - ARM Linux'; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH] ARM: Use asm-generic/sizes.h
>> Ah, I didn't notice this part. SZ_48M is actually used by ARM code so
>> that would need to be added to the generic header should we go with this
>> patch.
> IMO, the content of asm-generic/sizes.h should only include power-of-2 sizes definitions.
> And SZ_48M could be replaced by (SZ_32M | SZ_16M) or (SZ_32M + SZ_16M), or added to arch-specific headers.
>
>

I'm hoping that kbuild gets asm-generic support sometime soon so files
with only a "#include <asm-generic/*>" are generated instead of living
in the tree. In that case I'd rather have the non power of 2 constants
added to the generic sizes.h and be done with it. There isn't any strong
technical reason to deny power of 2 constants from the generic header,
right?

Note: SH could also move to this if SZ_26M is put in the generic header.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

