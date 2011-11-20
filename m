Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab1KTKQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 05:16:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59500 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab1KTKQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 05:16:18 -0500
MIME-Version: 1.0
In-Reply-To: <20110719003537.16b189ae@lilo>
References: <20110719003537.16b189ae@lilo>
Date: Sun, 20 Nov 2011 11:16:17 +0100
X-Google-Sender-Auth: GZAh6RlccWN-7NbgbrkkcHU7Rx8
Message-ID: <CAMuHMdWAhn7M8o0qY4pz3W1tyyKEcNY_YQL_6JuAPCcjL5vS1A@mail.gmail.com>
Subject: Re: Cross Memory Attach v3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
        linux-arch@vger.kernel.org, "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christopher,

On Mon, Jul 18, 2011 at 17:05, Christopher Yeoh <cyeoh@au1.ibm.com> wrote:
> For arch maintainers there are some simple tests to be able to quickly
> verify that the syscalls are working correctly here:

I'm wiring up these new syscalls on m68k.

> http://ozlabs.org/~cyeoh/cma/cma-test-20110718.tgz

The included README talks about:

    setup_process_readv_simple
    setup_process_readv_iovec
   setup_process_writev

while the actual test executables are called:

    setup_process_vm_readv_simple
    setup_process_vm_readv_iovec
    setup_process_vm_writev

On m68k (ARAnyM), the first and third test succeed. The second one
fails, though:

# Setting up target with num iovecs 10, test buffer size 100000
Target process is setup
Run the following to test:
./t_process_vm_readv_iovec 1574 10 0x800030b0 89 0x80003110 38302
0x8000c6b8 22423 0x80011e58 18864 0x80016810 583 0x80016a60 8054
0x800189e0 3417 0x80019740 368 0x800198b8 897 0x80019c40 7003

and in the other window:

# ./t_process_vm_readv_iovec 1574 10 0x800030b0 89 0x80003110 38302
0x8000c6b8 22423 0x80011e58 18864 0x80016810 583 0x80016a60 8054
0x800189e0 3417 0x80019740 368 0x800198b8 897 0x80019c40 7003
copy_from_process failed: Invalid argument
error code: 29
#

Any suggestions?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
