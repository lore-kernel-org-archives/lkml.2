Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab2DAQuD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:50:03 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:47693 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752833Ab2DAQuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:50:00 -0400
Message-ID: <4F788731.8020708@xenotime.net>
Date: Sun, 01 Apr 2012 09:49:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Zhihua Che <zhihua.che@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: How can I turn off/disable -O2/-Os optimization?
References: <CABexPfEdd0k9UGTJL9Ae5B=e_dDZMsTGg-LNYrOjLKzHBxuPwg@mail.gmail.com>
In-Reply-To: <CABexPfEdd0k9UGTJL9Ae5B=e_dDZMsTGg-LNYrOjLKzHBxuPwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2012 09:31 AM, Zhihua Che wrote:

> Hi, everyone
> 
>     I'm debugging linux kernel using kgdb/qemu， but I find that the
> execution order didn't math the program order usually.  I guess it was
> because the compiling optimization. So I decided to remove -O options
> in Makefiles.
>     First I removed -Ox in variables HOSTCFLAGS/HOSTCXXFLAGS in
> <src_root_dir>/Makefile around line 248 and -Ox in variable
> KBUILD_CFLAGS in <src_root_dir>/arch/x86/boot/Makefile around line 55.
> But it didn't work, the step execution still didn't follow the program
> order. Then I found I missed -Ox in KBUILD_CFLAGS in
> <src_root_dir>/Makefile around line 562, so I removed them, but this
> time, the compiling failed, complaining
>     rcupdate.h:917:2: error: size of unnamed array is negative
>    And finally, after grep, I find there are a load of -O2 option are
> assigned in a load of Makefiles. So, How could I disable -O
> optimization for debugging?
> 
>    Thanks for any tips
> --


You could try the new CONFIG_READABLE_ASM patch:
  http://marc.info/?l=linux-kernel&m=133296079716268&w=2


-- 
~Randy
