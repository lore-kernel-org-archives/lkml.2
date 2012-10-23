Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab2JWABE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 20:01:04 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43356 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab2JWABC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 20:01:02 -0400
Message-ID: <5085DE38.6030906@gmail.com>
Date: Mon, 22 Oct 2012 20:00:56 -0400
From: Daniel Hazelton <dshadowwolf@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com,
        drepper@gmail.com, paulmck@linux.vnet.ibm.com
Subject: tools/vm build fails
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After doing any build in the kernel (last attempt was an allmodconfig) 
I've tried to build the 'vm' tool in tools/vm and the build fails - 
looks to be fallout from the uapi header work.

[madman@localhost tools]$ make V=1 vm
make -C vm/
make[1]: Entering directory `/home/madman/sources/linux-2.6/tools/vm'
gcc -Wall -Wextra -o page-types page-types.c
In file included from page-types.c:38:0:
../../include/linux/kernel-page-flags.h:4:42: fatal error: 
uapi/linux/kernel-page-flags.h: No such file or directory
compilation terminated.
make[1]: *** [page-types] Error 1
make[1]: Leaving directory `/home/madman/sources/linux-2.6/tools/vm'
make: *** [vm] Error 2

I'm not a kernel developer (I've tried and been unable to wrap my head 
around any part that I was going to try working on :( )and was just 
trying bits in tools/ at random to see what, exactly, they were and this 
kept happening, no matter the state of the tree.

I updated my git tree about 3 hours ago to mirror the latest Linus from 
git.kernel.org after having run into this error yesterday and deciding I 
must have done something wrong. This looks like it might be a missing -I 
or similar since the file does exist and is at that exact path from the 
file that is directly including it.

DRH
