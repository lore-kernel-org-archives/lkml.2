Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435Ab0FPTHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 15:07:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54457 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758747Ab0FPTHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 15:07:46 -0400
Message-ID: <4C192113.7030101@vlnb.net>
Date: Wed, 16 Jun 2010 23:08:03 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: sparclinux@vger.kernel.org
CC: Simone Ricci <simone.ricci@gmail.com>, scst-devel@lists.sourceforge.net,
       Joe Eykholt <jeykholt@cisco.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: How to printk/sprintf uint64_t on Sparc without format and argument
 types mismatch
References: <AANLkTimuv7nOlcGFxqPZlwcAjLmFMiLAvbA5O7F32Wbg@mail.gmail.com>
In-Reply-To: <AANLkTimuv7nOlcGFxqPZlwcAjLmFMiLAvbA5O7F32Wbg@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1+v3XirkF2wF6M/uTDTpJE0hL/4tZxOGIAbbDl
 bNHp7SqLtuJWgqT2PDJYYBhRtVLagtky7vpIKcp3YjjgOXpUnk
 wHbdJW79Moamr4Xn5uScw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We in SCST project need to printk/sprintf variables of type uint64_t. 
Size of those variables is required to be 64-bit integer. On x86 we 
printk/sprintf them as %lld, but on Sparc we have a compiler warnings like:

scst/src/scst_targ.c:2136: warning: format ‘%llx’ expects type ‘long 
long unsigned int’, but argument 4 has type ‘uint64_t’.

It is because on Sparc uint64_t defined as unsigned long, but on x86 - 
as unsigned long long.

Sure, we can cast all the cases to unsigned long long, but we wonder, 
maybe there is a more elegant way to do that without the warning? For 
instance, like %z for size_t or PRId64 in the user space.

Thanks,
Vlad

