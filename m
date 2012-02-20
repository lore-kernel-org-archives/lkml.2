Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab2BTHqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 02:46:45 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7163 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2BTHqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 02:46:44 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6625"; a="162284331"
Message-ID: <4F41FA60.7090503@codeaurora.org>
Date: Sun, 19 Feb 2012 23:46:40 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Fix and simplify debugfs support
References: <1329636505-13651-1-git-send-email-sboyd@codeaurora.org> <20120220021157.GF3194@opensource.wolfsonmicro.com>
In-Reply-To: <20120220021157.GF3194@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/19/2012 6:12 PM, Mark Brown wrote:
> On Sat, Feb 18, 2012 at 11:28:25PM -0800, Stephen Boyd wrote:
>> If CONFIG_DEBUG_FS=y debugfs functions will never return an
>> ERR_PTR. Instead they'll return NULL. The intent is to remove
>> ifdefs in calling code.
>> Instead of checking for an ERR_PTR check for NULL. This simplifies
>> the code and also fixes an error check that would never have
>> worked otherwise. While we're here modernize the code to use
>> S_IRUGO instead of 0444.
> This was actually a deliberate decision to make the code more robust
> against change - the IS_ERR_OR_NULL doesn't make the code any bigger but
> it means it's less likely to break in the face of changes.

More robust? The debugfs code in the regulator core looks confused on 
what the return value is. Sometimes it's IS_ERR, sometimes it's NULL, 
sometimes it's both. Might as well clean it up to be consistent and proper.

>> If we're willing to sacrifice a pointer per rdev we can remove the
>> ifdefs and the compiler should be able to optimize away the dead
>> code.
> Personally I'd be happy to do that, the only reason I put the ifdefs in
> there was that it appears to be idiomatic to do so but I'm not really a
> big fan of it.  Then again I never build kernls without debugfs support
> in them myself...

Ok. I'll send a patch to do that too.

How about a two part series with the erroneous error check fix in one 
and then the other stuff that isn't critical in another?
