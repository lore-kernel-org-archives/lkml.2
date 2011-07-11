Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab1GKU13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 16:27:29 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:63600 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab1GKU11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 16:27:27 -0400
Message-ID: <4E1B5CAA.7070001@gmail.com>
Date: Mon, 11 Jul 2011 22:27:22 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org, cl@linux.com
Subject: page->_count build failure [was: mmotm 2011-07-08-12-50 uploaded]
References: <201107082028.p68KSWWf013053@imap1.linux-foundation.org>
In-Reply-To: <201107082028.p68KSWWf013053@imap1.linux-foundation.org>
X-Enigmail-Version: 1.2pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2011 09:50 PM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2011-07-08-12-50 has been uploaded to

Hi, am I the only one encountering a build failure due to double
definition of _count in page struct introduced by:
commit fc9bb8c768abe7ae10861c3510e01a95f98d5933
Author: Christoph Lameter <cl@linux.com>
Date:   Wed Jun 1 12:25:48 2011 -0500

    mm: Rearrange struct page

in the -next tree?

$ make
...
  CC      arch/x86/kernel/asm-offsets.s
In file included from include/linux/sched.h:64:0,
                 from arch/x86/kernel/asm-offsets.c:9:
include/linux/mm_types.h:74:15: error: duplicate member ‘_count’
make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2
$ gcc --version
gcc (SUSE Linux) 4.6.0 20110607 [gcc-4_6-branch revision 174741]

regards,
-- 
js
