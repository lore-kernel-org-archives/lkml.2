Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab0JYWu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 18:50:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab0JYWu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 18:50:58 -0400
Date: Mon, 25 Oct 2010 18:50:55 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: conflicting options in makefile ?
Message-ID: <20101025225055.GA6840@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While diagnosing a ccache problem, I noticed the following command line being used..

[2010-10-25T18:45:16.715078 25689] Executing /usr/bin/cc -D__KERNEL__
-Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing
-fno-common -Werror-implicit-function-declaration -Wno-format-security
-fno-delete-null-pointer-checks -Os -m64 -mtune=generic -mno-red-zone
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args
-fstack-protector -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1
-DCONFIG_AS_CFI_SECTIONS=1 -DCONFIG_AS_FXSAVEQ=1 -pipe -Wno-sign-compare
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow
-Wframe-larger-than=2048 -fno-omit-frame-pointer
-fno-optimize-sibling-calls -g -femit-struct-debug-baseonly -pg
-Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow
-fconserve-stack -DCC_HAVE_ASM_GOTO -fno-unit-at-a-time -c -xc /dev/null
-o .25644.tmp


Note that we pass -funit-at-a-time and -fno-unit-at-a-time.
Looking at arch/x86/Makefile, there's a test that adds the -fno-unit-at-a-time.
if gcc is < 4.0 (I'm using 4.5)

What's happening here?

	Dave

