Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab0JAL2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:28:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57588 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab0JAL2b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:28:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o5/d3xOgf0/csW3RPprQa4wPStaXIBJAzzB9hE6l4ivvdxx4VrdiZWlQGvjjO29PfP
         kDdb+Q5gmLn0iMC/Umd3vNCgnwzbhd9Iu6fEM60wKAwPxtX4pT85opgHqqXP7IXa6ekH
         XwNCcYxqTPeXc3/q+aY8pvU9yUXtcfvn0kh5o=
MIME-Version: 1.0
In-Reply-To: <F7E7DAE6-A132-458D-ABC3-4CC92A4C7263@kernel.crashing.org>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
	<1285916771-18033-2-git-send-email-imunsie@au1.ibm.com>
	<F7E7DAE6-A132-458D-ABC3-4CC92A4C7263@kernel.crashing.org>
Date: Fri, 1 Oct 2010 07:28:30 -0400
Message-ID: <AANLkTimGtB_KoOgwk3Ujn2UcNzs9qHxzeZcb1ShLgcXh@mail.gmail.com>
Subject: Re: [PATCH 01/18] powerpc: Add ability to build little endian kernels
From: Josh Boyer <jwboyer@gmail.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Ian Munsie <imunsie@au1.ibm.com>, Michal Marek <mmarek@suse.cz>,
        Albert Herranz <albert_herranz@yahoo.es>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, Andreas Schwab <schwab@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Torez Smith <lnxtorez@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 1, 2010 at 5:18 AM, Kumar Gala <galak@kernel.crashing.org> wrote:
>
> On Oct 1, 2010, at 2:05 AM, Ian Munsie wrote:
>
>>
>> diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
>> index d361f81..074ff12 100644
>> --- a/arch/powerpc/platforms/Kconfig.cputype
>> +++ b/arch/powerpc/platforms/Kconfig.cputype
>> @@ -329,3 +329,19 @@ config CHECK_CACHE_COHERENCY
>>       bool
>>
>> endmenu
>> +
>> +config ARCH_SUPPORTS_LITTLE_ENDIAN
>> +     bool
>> +
>> +config CPU_LITTLE_ENDIAN
>> +     bool "Build little endian kernel"
>> +     depends on ARCH_SUPPORTS_LITTLE_ENDIAN && EXPERIMENTAL
>> +     default n
>> +     help
>> +       This option selects whether a big endian or little endian kernel will
>> +       be built.
>> +
>> +       Note that if building a little endian kernel, CROSS_COMPILE must
>> +       point to a toolchain capable of targetting little endian powerpc,
>> +       while the toolchain specified by CROSS32_COMPILE must be capable of
>> +       targetting *BIG* endian PowerPC.
>> --
>> 1.7.1
>
> Shouldn't we have something that limits to the sub-arch'es that actually support it?  I doubt I'm ever going to make FSL-Book-e support LE.

Yes, it should.

josh
