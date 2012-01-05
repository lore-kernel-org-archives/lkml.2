Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab2AETfC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 14:35:02 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:39847 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758249Ab2AETeo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 14:34:44 -0500
MIME-Version: 1.0
In-Reply-To: <20120105143008.GA31728@elliptictech.com>
References: <20120104201800.GA2587@www.outflux.net>
	<20120105143008.GA31728@elliptictech.com>
Date: Thu, 5 Jan 2012 11:34:43 -0800
X-Google-Sender-Auth: KDlVxQ3DJTV95NhpBBdkPWvdKEg
Message-ID: <CAGXu5jLYhxOK8u-H8mhTvHBzvkRi8d-=zTeginjukDMEFri-0Q@mail.gmail.com>
Subject: Re: [PATCH v2012.1] fs: symlink restrictions on sticky directories
From: Kees Cook <keescook@chromium.org>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Federica Teodori <federica.teodori@googlemail.com>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 6:30 AM, Nick Bowler <nbowler@elliptictech.com> wrote:
> On 2012-01-04 12:18 -0800, Kees Cook wrote:
>> diff --git a/fs/Kconfig b/fs/Kconfig
>> index 5f4c45d..26ede24 100644
>> --- a/fs/Kconfig
>> +++ b/fs/Kconfig
>> @@ -278,3 +278,19 @@ source "fs/nls/Kconfig"
>>  source "fs/dlm/Kconfig"
>>
>>  endmenu
>> +
>> +config PROTECTED_STICKY_SYMLINKS
>> +     bool "Protect symlink following in sticky world-writable directories"
>> +     default y
> [...]
>
> Why do we need a config option for this?  What's wrong with just using
> the sysctl?

This way the sysctl can configured directly without needing to have a
distro add a new item to sysctl.conf.

> Why have you made this option "default y", when enabling it clearly
> makes user-visible changes to kernel behaviour?

Ingo specifically asked me to make it "default y".

-Kees

-- 
Kees Cook
ChromeOS Security
