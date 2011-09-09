Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab1IIEuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 00:50:09 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43506 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1IIEuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 00:50:07 -0400
MIME-Version: 1.0
In-Reply-To: <4E67699E.80208@suse.cz>
References: <CABG-yt0t0sgAvcDDLhjyNFGpY22tL0CtDvXV9+CxYJMf0MdVfA@mail.gmail.com>
	<4E67699E.80208@suse.cz>
Date: Fri, 9 Sep 2011 10:20:04 +0530
Message-ID: <CABG-yt030LAdqbRySzs8sj0Ajwst_c8RHf7yOyG9Eihh6mmf+w@mail.gmail.com>
Subject: Re: CRC calculation in Module.symvers
From: Shakthi Kannan <shakthimaan@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

--- On Wed, Sep 7, 2011 at 6:24 PM, Michal Marek <mmarek@suse.cz> wrote:
| You need at least -include include/generated/autoconf.h
\--

I tried using:

$  gcc -E -D__GENKSYMS__ -DCONFIG_MODVERSIONS -DEXPORT_SYMTAB
crypto/api.c -I/tmp/linux-3.0.2/include
-I/tmp/linux-3.0.2/arch/x86/include -include
include/generated/autoconf.h  | ./scripts/genksyms/genksyms

and it returned the checksums like:

  __crc_crypto_alg_list = 0x86fb488e ;
  __crc_crypto_alg_sem = 0xb7865a4f ;
  __crc_crypto_chain = 0x2f947450 ;
  __crc_crypto_mod_get = 0x67cda209 ;
  ...

But, in Module.symvers there is only crypto_mod_get and its checksum
is 0x3286637f which is different from the one listed above.

---
| $ make V=1 crypto/api.symtypes
|
| this will generate a file with the symbol expansions.
\--

This generated the api.symtypes file.

---
| And if you copy
| the commandline without the >/dev/null redirection, you'll see the
| calculated checksums on standard output.
\--

Sorry, I didn't understand. Can you elaborate on what needs to be done here?

Thanks for your reply,

SK

-- 
Shakthi Kannan
http://www.shakthimaan.com
