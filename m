Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab2BQMHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 07:07:01 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45265 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab2BQMHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 07:07:00 -0500
Message-ID: <4F3E42E0.4030108@openvz.org>
Date: Fri, 17 Feb 2012 16:06:56 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20120201 Iceape/2.0.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (akpm
 tree related)
References: <20120217212037.0859c427418b73b2cb17428d@canb.auug.org.au>
In-Reply-To: <20120217212037.0859c427418b73b2cb17428d@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Andrew,
>
> Today's linux-next fails to build (s390 allnoconfig) like this:
>
> In file included from arch/s390/mm/maccess.c:15:
> include/linux/gfp.h: In function 'gfp_zonelist':
> include/linux/gfp.h:267: error: '__enabled_CONFIG_NUMA' undeclared (first use in this function)
> include/linux/gfp.h:267: error: (Each undeclared identifier is reported only once
> include/linux/gfp.h:267: error: for each function it appears in.)
> include/linux/gfp.h:267: error: '__enabled_CONFIG_NUMA_MODULE' undeclared (first use in this function)
>
> and many more.  This also happens in other architectures and configs but
> (obviously) not all builds.
>
> Presumably caused by commit 053361e1a072 ("mm: replace NUMA_BUILD with
> IS_ENABLED(CONFIG_NUMA)").
>

Oops, yes, my fault.

'config NUMA' defined in arch-specific Kconfig, some of them does not have it.
Thus Kconfig generates these constants not for all architectures.

config MIGRATION and config COMPACTION already in generic mm/Kconfig
