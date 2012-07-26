Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab2GZRDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 13:03:16 -0400
Received: from oproxy10-pub.bluehost.com ([67.222.39.61]:44439 "HELO
	oproxy10-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752401Ab2GZRDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 13:03:14 -0400
Message-ID: <50117812.5080302@xenotime.net>
Date: Thu, 26 Jul 2012 10:02:10 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Salar Ali Mumtaz <salaarali@gmail.com>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xconfig: Display dependency values in debug_info
References: <1343256982-11421-1-git-send-email-salaarali@gmail.com> <50107EB7.8000009@xenotime.net> <CA+jpPM=nrbpDJpaka6xAp4dbEOQjJrtwQWtUXwi_gGS9b4yK-A@mail.gmail.com>
In-Reply-To: <CA+jpPM=nrbpDJpaka6xAp4dbEOQjJrtwQWtUXwi_gGS9b4yK-A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 09:19 AM, Salar Ali Mumtaz wrote:

> Hi.
> 
> Thanks for the quick reply.
> 
> This adds the current values to the dependencies in the debug_info, which you get when you select "Show debug info" 
> from the popup you get after you right click. For some values, there is no help available. For those, there is usually 
> information in the debug_info that is not displayed normally.
> 
> COMPAT_BINFMT_ELF
> 
> //This is added by debug_info
> type: boolean
> reverse dep: (IA32_EMULATION n && X86_64 n ) =n
> unknown property: symbol
>     dep: ( COMPAT n && BINFMT_ELF y ) =n
> //This is added by debug_info
> 
> defined at fs/Kconfig.binfmt:26
> 
> There is no help available for this option.
> Symbol: COMPAT_BINFMT_ELF [=n]
> Type : boolean
> Selected by: IA32_EMULATION [=n] && X86_64 [=n]
> 
> Hope this helps.
> 


Yes, it does help.  Thanks.


For BINFMT_ELF (not your example of COMPAT_BINFMT_ELF)
in Linux 3.5, I see this:


BEFORE PATCH:

type: boolean
unknown property: symbol
    dep: MMU && (BROKEN || !FRV)
prompt: Kernel support for ELF binaries
    dep: MMU && (BROKEN || !FRV)
default: y
    dep: MMU && (BROKEN || !FRV)

defined at fs/Kconfig.binfmt:1



AFTER PATCH:

type: boolean
unknown property: symbol
    dep: ( MMU y && (BROKEN n || !FRV FRV) ) =y
prompt: Kernel support for ELF binaries
    dep: ( MMU y && (BROKEN n || !FRV FRV) ) =y
default: y
    dep: ( MMU y && (BROKEN n || !FRV FRV) ) =y

defined at fs/Kconfig.binfmt:1




The added y/n/m are clear, but the "!FRV FRV" is confusing,
isn't it?


-- 
~Randy
