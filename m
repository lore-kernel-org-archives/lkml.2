Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab0G1F0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 01:26:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:59033 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab0G1F0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 01:26:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,271,1278313200"; 
   d="scan'208";a="305228740"
Message-ID: <4C4FBF63.2040609@linux.intel.com>
Date: Tue, 27 Jul 2010 22:25:55 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [tip:x86/build] x86, vdso: Error out if the vdso contains external
 references
References: <tip-*@vger.kernel.org>	<tip-05d0b0889ca9d033a960542af7f8a13b3ad4f630@git.kernel.org> <20100728134252.2e4c27cf.sfr@canb.auug.org.au>
In-Reply-To: <20100728134252.2e4c27cf.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi,
> 
> On Fri, 18 Jun 2010 22:16:05 GMT "tip-bot for H. Peter Anvin" <hpa@linux.intel.com> wrote:
>> diff --git a/arch/x86/vdso/checkundef.sh b/arch/x86/vdso/checkundef.sh
>> new file mode 100755
>> index 0000000..490be1c
>> --- /dev/null
>> +++ b/arch/x86/vdso/checkundef.sh
>> @@ -0,0 +1,10 @@
>> +#!/bin/sh
>> +nm="$1"
>> +file="$2"
>> +"$nm" "$file" | grep '^ *U' > /dev/null 2>&1
> 
> Quoting $nm here doesn't work if you are building with ccache like this:
> 
> make CROSS_COMPILE="ccache ...."

Hmmm... in some ways I'm not sure if that's a feature or a bug, but I 
guess it's the only way currently provided.  Sigh.

	-hpa
