Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab2HWCCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:02:10 -0400
Received: from mail1.windriver.com ([147.11.146.13]:41753 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab2HWCCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:02:05 -0400
Message-ID: <50358D6E.20209@windriver.com>
Date: Thu, 23 Aug 2012 09:54:54 +0800
From: "tiejun.chen" <tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Tabi Timur-B04825 <B04825@freescale.com>
CC: "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] powerpc: Bail out of KGDB when we've been triggered
References: <1345632192-19810-1-git-send-email-tiejun.chen@windriver.com> <1345632192-19810-2-git-send-email-tiejun.chen@windriver.com> <6AE080B68D46FC4BA2D2769E68D765B7059AE7E7@039-SN2MPN1-022.039d.mgd.msft.net>
In-Reply-To: <6AE080B68D46FC4BA2D2769E68D765B7059AE7E7@039-SN2MPN1-022.039d.mgd.msft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 11:07 PM, Tabi Timur-B04825 wrote:
> On Wed, Aug 22, 2012 at 5:43 AM, Tiejun Chen <tiejun.chen@windriver.com> wrote:
> 
>> +int kgdb_skipexception(int exception, struct pt_regs *regs)
>> +{
>> +       if (kgdb_isremovedbreak(regs->nip))
>> +               return 1;
>> +
>> +       return 0;
>> +}
> 
> int kgdb_skipexception(int exception, struct pt_regs *regs)
> {
>         return !!kgdb_isremovedbreak(regs->nip));
> }
> 
> If the caller only cares about zero vs. non-zero, you can drop the !!.

Yes, so 'return kgdb_isremovedbreak(regs->nip);' is already fine and simple.

I'll update this as v2 so thanks your comment.

Tiejun
