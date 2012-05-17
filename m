Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab2EQF4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 01:56:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37208 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab2EQF4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 01:56:08 -0400
Message-ID: <4FB492F7.8050401@gmail.com>
Date: Thu, 17 May 2012 13:56:07 +0800
From: hacklu <embedway.linux@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:13.0) Gecko/20120425 Thunderbird/13.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: why the decompressed procedure move kernel from address 0x100000(1M)
 to 0x1000000(16M) +x
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all,
recently, I got some puzzle when I read source code of the system boot. 
I need some help.

at the end of src/arch/x86/boot/header.S,  kernel jump to 0x100000(where 
is the src/arch/x86/boot/compressed/head_32.S).
in __this__ head_32.S, I found the kernel is move to 0x1000000(mostly is 
to here) +x. the x distance is used for decompressed buf.  must leave 
some distance for decompressing without overlap.

after the move, kernel is decompressed at 0x1000000(16m). and jump to it.

so why not decompressed kernel at 0x100000(1M) to 0x1000000(16m) 
directly without moving?

is the move necessary?

thanks for reading above.
