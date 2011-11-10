Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986Ab1KJSx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 13:53:27 -0500
Received: from gate.crashing.org ([63.228.1.57]:51665 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132Ab1KJSxY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 13:53:24 -0500
Subject: Re: [RFC PATCH 16/17] powerpc/e500: Make __setup_cpu_{e200,e500,e500mc,e5500} optional
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20111110164741.GC11983@schlenkerla.am.freescale.net>
Date: Thu, 10 Nov 2011 12:52:36 -0600
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, Baruch Siach <baruch@tkos.co.il>,
        Timur Tabi <B04825@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Shaohui Xie <b21989@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <45E2D05B-B8B9-4254-910C-F24757C59A22@kernel.crashing.org>
References: <4E42AB6F.1050900@freescale.com> <1320883635-17194-17-git-send-email-Kyle.D.Moffett@boeing.com> <20111110164741.GC11983@schlenkerla.am.freescale.net>
To: Scott Wood <scottwood@freescale.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 10, 2011, at 10:47 AM, Scott Wood wrote:

> On Wed, Nov 09, 2011 at 07:07:14PM -0500, Kyle Moffett wrote:
>> Only build the setup functions when the corresponding entries are
>> included in the CPU table.
>> 
>> Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
>> ---
>> arch/powerpc/kernel/cpu_setup_fsl_booke.S |   14 +++++++++++++-
>> 1 files changed, 13 insertions(+), 1 deletions(-)
>> 
>> diff --git a/arch/powerpc/kernel/cpu_setup_fsl_booke.S b/arch/powerpc/kernel/cpu_setup_fsl_booke.S
>> index 8053db0..77721b2 100644
>> --- a/arch/powerpc/kernel/cpu_setup_fsl_booke.S
>> +++ b/arch/powerpc/kernel/cpu_setup_fsl_booke.S
>> @@ -17,6 +17,8 @@
>> #include <asm/cputable.h>
>> #include <asm/ppc_asm.h>
>> 
>> +#if defined(CONFIG_FSL_E500_V1_V2) || defined(CONFIG_FSL_E500MC) \
>> +		|| defined(CONFIG_FSL_E5500)
> 
> This seems like the kind of thing that CONFIG_E500 should be retained
> for.
> 
> -Scott

Agreed, we should define CONFIG_E500 as internal and used for common functionality between E500, E500MC, E5500, E6500.

- k