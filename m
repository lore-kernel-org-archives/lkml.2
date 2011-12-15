Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab1LOHvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:51:45 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41931 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab1LOHvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:51:44 -0500
MIME-Version: 1.0
Date: Thu, 15 Dec 2011 15:51:44 +0800
Message-ID: <CAOvLkw08BQjexftPZbKCL83uuSaAS7Cn2q2rAamewDDbVtPcxw@mail.gmail.com>
Subject: a problem in cpucheck.c on x86
From: ttlxzz ccc <boyzccc@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,all:

In arch/x86/boot/cpucheck.c
static int has_eflag(u32 mask)
{
	u32 f0, f1;

	asm("pushfl ; "
	    "pushfl ; "
	    "popl %0 ; "
	    "movl %0,%1 ; "
	    "xorl %2,%1 ; "
	    "pushl %1 ; "
	    "popfl ; "
	    "pushfl ; "
	    "popl %1 ; "
	    "popfl"
	    : "=&r" (f0), "=&r" (f1)
	    : "ri" (mask));

	return !!((f0^f1) & mask);
}

	    "pushl %1 ; "
	    "popfl ; "
	    "pushfl ; "
	    "popl %1 ; "
I don't know what does above 4 instructions do, and I rewirte it like this:

static int has_eflag(u32 mask)
{
        u32 f0;

        asm("pushfl ; "
            "pushfl ; "
            "popl %0 ; "
            "popfl"
            : "=&r" (f0));

        return ~f0 & mask;

}
It works well, and I just want to know is there some special meanings
of the 4 instructions?
	    "pushl %1 ; "
	    "popfl ; "
	    "pushfl ; "
	    "popl %1 ; "
