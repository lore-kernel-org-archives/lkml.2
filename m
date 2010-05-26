Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab0EZRmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 13:42:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63221 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251Ab0EZRmF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 13:42:05 -0400
MIME-Version: 1.0
Message-ID: <d1278473-1065-4607-98e0-67f2b985ec15@default>
Date: Wed, 26 May 2010 10:41:43 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: tsc reliability for Intel Core 2 Duo "Conroe"
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4BFD5D63.0194:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking through code following up on the separate TSC-related
thread, I noticed that my Intel Core 2 Duo "Conroe" box
is determined to have an unstable TSC, so falls back
to clocksource==hpet.

While a Conroe has X86_FEATURE_CONSTANT_TSC and not
X86_FEATURE_NONSTOP_TSC, a Conroe is only able to enter
C0 and C1 (unlike its sister Intel Core 2 Duo processor
"Merom" which can enter C0-C3).

I was under the impression (possibly from an earlier kernel
version?) that tsc_constant PLUS inability to enter deep-C
states would result in an acceptably stable TSC to use
as a clocksource (assuming it passes a TSC warp test).

So is this a bug?  Or is my impression incorrect?

See tsc_check_state() in drivers/acpi/processor_idle.c.
I can submit a patch, but wanted to check first.
