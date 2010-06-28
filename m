Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab0F1Wos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 18:44:48 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:42700 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab0F1Woq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 18:44:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TNeicwijhC6yZzaTatcMyjq3hh6kdN7xWdCpkpbZWgxFRV6vPc0qNgQusLVGmas4XY
         igKVOI6xMBv9GiwZt/RoH7KIHUx6wKYX3byrobhifCp39NoZ3skt+hh3m804aibqJ9uT
         HloIvPTvshyDBa8U5SxUgcSPGuhPHourMV6jM=
Date: Mon, 28 Jun 2010 15:44:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>,
       "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: problem: Re: [PATCH] input: fixup X86_MRST selects
Message-ID: <20100628224440.GA19087@core.coreip.homeip.net>
References: <20100609133443.38f1f957.sfr@canb.auug.org.au>
 <201006101204.45709.dmitry.torokhov@gmail.com>
 <4C28F210.7030909@oracle.com>
 <201006281318.16377.dmitry.torokhov@gmail.com>
 <4C2904D0.3000409@oracle.com>
 <43F901BD926A4E43B106BF17856F0755EA339079@orsmsx508.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43F901BD926A4E43B106BF17856F0755EA339079@orsmsx508.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 02:12:03PM -0700, Pan, Jacob jun wrote:
> >
> We do intend to maintain binary compatibility between generic kernel and Moorestown.
> I guess the challenge is not having enumeration of i8042 pass to the driver. Do you
> prefer abort i8042_platform_init() based on #define CONFIG_X86_MRST? It is no safe
> to probe HW on Moorestown, unfortunately.

Any check based on CONFIG_X86_MRST means that kernel is not generic.
We'd need a runtime check (but not necessarily one that bangs ports). Is
there something in processor flags, or DMI, or similar that woudl allow
i8042 to see that it runs on Moorestown?

-- 
Dmitry
