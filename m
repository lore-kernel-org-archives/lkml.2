Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287Ab2EQBRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 21:17:49 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:20880 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752442Ab2EQBRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 21:17:48 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2fh2a8h668h839hd25h)
X-Forefront-Antispam-Report: CIP:160.33.194.230;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail03v.am.sony.com;RD:mail03.sonyusa.com;EFVD:NLI
Message-ID: <4FB451A6.4030306@am.sony.com>
Date: Wed, 16 May 2012 18:17:26 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH RT 2/2] fix printk flush of messages
References: <4FB44EF1.9050809@am.sony.com> <4FB44FD0.4090800@am.sony.com>
In-Reply-To: <4FB44FD0.4090800@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches were tested on an ARM panda board for linux-3.4-rc5-rt6.

The panda board has a compile error in linux-3.4-rc5, which is fixed
by commit 13176a89e1c4a0011bd9f576730b0338ecb619ff in linux-3.4-rc6.

Without the patch, the printk() output from the following commands
does not appear on the console, until flushed by 'echo >/dev/console'

   echo h >/proc/sysrq-trigger
   echo p >/proc/sysrq-trigger
   echo m >/proc/sysrq-trigger

With the patch, the output flushes to the console immediately.

-Frank

