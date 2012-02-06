Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab2BFXF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 18:05:29 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29884 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066Ab2BFXF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 18:05:27 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6612"; a="161015883"
Message-ID: <4F305CB6.7050603@codeaurora.org>
Date: Mon, 06 Feb 2012 15:05:26 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tags: fix regex passed to etags and ctags
References: <20120203112701.1c12b12c@s6510.linuxnetplumber.net>	<4F2C38BD.1060109@codeaurora.org>	<20120203121847.1b01f4b5@s6510.linuxnetplumber.net>	<c1f3d71b6001dfc42ded4ee651e9a82c.squirrel@www.codeaurora.org> <20120206124058.1cf1a23e@s6510.linuxnetplumber.net>
In-Reply-To: <20120206124058.1cf1a23e@s6510.linuxnetplumber.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/12 12:40, Stephen Hemminger wrote:
> Several of the regular expressions passed to etags and ctags where incorrect
> and missing the backslash before the closing paren, causing warning:
>   etags: Unmatched ( or \( while compiling pattern
>
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>
> ---
> v2 - cover all regex (not just etags)
>

Ok one more problem (my eyes hurt with all these parentheses).

--regex-c++='/PAGEFLAG\(([^,)]*\).*/Page\1/'


should be

--regex-c++='/PAGEFLAG(\([^,)]*\).*/Page\1/'


so that PAGEFLAG(Foo, ...) becomes PageFoo and not Page(Foo

After that:

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

