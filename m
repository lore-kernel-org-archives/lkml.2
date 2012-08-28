Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab2H1G51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 02:57:27 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:55430 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2H1G5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 02:57:17 -0400
Message-ID: <503C6B5D.9030100@linux.vnet.ibm.com>
Date: Tue, 28 Aug 2012 12:25:25 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Andi Kleen <andi@firstfloor.org>, tony.luck@intel.com,
        gong.chen@linux.intel.com, ananth@in.ibm.com,
        masbock@linux.vnet.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, lcm@us.ibm.com, mingo@redhat.com,
        tglx@linutronix.de, linux-edac@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/mce: Pack boolean MCE boot flags into a structure
References: <20120827112503.10313.62594.stgit@localhost.localdomain> <20120827135859.GY16230@one.firstfloor.org> <20120827141845.GB27979@aftab.osrc.amd.com>
In-Reply-To: <20120827141845.GB27979@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12082806-3864-0000-0000-0000045C397B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 07:48 PM, Borislav Petkov wrote:
> On Mon, Aug 27, 2012 at 03:58:59PM +0200, Andi Kleen wrote:
>> On Mon, Aug 27, 2012 at 04:55:03PM +0530, Naveen N. Rao wrote:
>>> Many MCE boot flags are boolean in nature, but are declared as integers
>>> currently. We can pack these into a bitfield to save some space.
>>
>> Note that this doesn't necessarily save anything because it needs more
>> code to access, and accesses are more common than the flag
>>
>> 	cmpl  $0,foo(%rip)            7 bytes
>>          testl $1,foo(%rip)           10 bytes
>
> I got 7 bytes:
>
> 12e9:       f6 05 00 00 00 00 02    testb  $0x2,0x0(%rip)        # 12f0 <mce_start_timer.isra.18+0x30>
>
> vs the old:
>
> 1654:       83 3d 00 00 00 00 00    cmpl   $0x0,0x0(%rip)        # 165b <mce_start_timer.clone.15+0x37>
>
> also 7 bytes.
>

I'm seeing the same here. GCC v4.7 with -O2 generates testb and cmpb, 
which are both 7 bytes long.

Thanks,
Naveen

