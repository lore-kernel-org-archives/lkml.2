Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0K3Ke1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 05:34:27 -0500
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:3383 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755196Ab0K3Ke0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 05:34:26 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host oAUAYLxY015957
Subject: Re: [PATCH] Repalce strncmp by memcmp
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: pavel@pavlinux.ru
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4CF30B46.4000203@pavlinux.ru>
References: <4CF30B46.4000203@pavlinux.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 11:34:20 +0100
Message-ID: <1291113260.16068.13.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-DCC-STAT_FI_X86_64_VIRTUAL-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 05:09 +0300, Pavel Vasilyev wrote: 
> This patch replace all strncmp(a, b, c) by  memcmp(a, b, c).
> 
> I test on x86_64 (AMD Opteron 285).
> 
> #include <string.h>
> char *A = "0000";
> void test_memcmp(void) {
>         memcmp(A, "TEST", 4);
> }
> void test_strn(void) {
>         strncmp(A, "TEST", 4);
> }
[...]

You use constant parameters with user-space functions defined by the
C-standard on one architecture (and CPU?) - and even worse the width is
4 so - for the memcmp() case - it boilsdown to a comparison of unsigned
ints.
So that example is (also) completely worthless.

Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

