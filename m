Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab0LJHan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 02:30:43 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:64372 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966Ab0LJHam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 02:30:42 -0500
Message-ID: <4D01D70A.5050508@lougher.demon.co.uk>
Date: Fri, 10 Dec 2010 07:30:18 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Lasse Collin <lasse.collin@tukaani.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        Linux Embedded Maillist <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH 2/2] Squashfs: Add XZ compression configuration option
References: <4D007315.1090704@lougher.demon.co.uk> <201012091109.32084.lasse.collin@tukaani.org>
In-Reply-To: <201012091109.32084.lasse.collin@tukaani.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lasse Collin wrote:
> On 2010-12-09 Phillip Lougher wrote:
>> +config SQUASHFS_XZ
>> +       bool "Include support for XZ compressed file systems"
>> +       depends on SQUASHFS
>> +       default n
>> +       select XZ_DEC
> 
> Should "select XZ_DEC" be replaced with "depends on XZ_DEC"? XZ_DEC 
> requires CRC32, so if "select XZ_DEC" is used, there needs to be also 
> "select CRC32".
> 

XZ_DEC selects CRC32, kbuild handles these nested selects quite happily,
so if something selects XZ_DEC it knows it has to also select CRC32.

Depends on has quite different semantics to selects.  If SQUASHFS_XZ
was made to depend on XZ_DEC then the option simply won't appear unless
the user knew to select XZ_DEC first (as it's default n).  This would
prove extremely confusing, and probably lead to most people thinking
Squashfs didn't have XZ support, which is somewhat undesirable.

> XZ_DEC may optionally use other XZ_DEC_* symbols, which the user will 
> want to choose when building for an embedded system. With "depends on 
> XZ_DEC" the user will see that there's more than a single option that 
> affects the details of the XZ support in Squashfs.
>

With depends on XZ_DEC the user will simply not see that Squashfs has
XZ support (as the option won't appear unless XZ_DEC is explicitly
selected).

With selects XZ_DEC users will see that Squashfs has XZ support, if
enabled, they'll simply see that XZ_DEC has been automatically
selected in the "Library routines" sub-menu.  If EMBEDDED is not
selected the XZ_DEC options will be automatically selected (as
they're only user selectable if EMBEDDED is selected).  If
EMBEDDED is selected, then they'll have the choice then to decide
which options they wish to de-select.

I think this is preferable to needing XZ_DEC to be selected before
the SQUASHFS_XZ option even appears.

Phillip

