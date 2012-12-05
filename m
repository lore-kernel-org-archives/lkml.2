Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab2LEK1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 05:27:50 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37167 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab2LEK1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 05:27:49 -0500
MIME-Version: 1.0
Date: Wed, 5 Dec 2012 11:27:48 +0100
Message-ID: <CAF6-1L7qDULSvzaB2G=8y9Jkyd=SfcDBnNTxTuN0xSQxG94CHg@mail.gmail.com>
Subject: Wrong length / buffer overlow by the syslog syscall
From: Sylvain Munaut <s.munaut@whatever-company.com>
To: linux-kernel@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was debugging a segfault in the 'dmesg' utility that I finally
traced to the syslog syscall overflowing the buffer.
I'm under a 3.6.8 kernel and it has commit
e3756477aec028427fec767957c0d4b6cfb87208 present which apparently
fixed a similar issue, but I still have some occurence.

strace dmesg -s 8192

shows:

syslog(0x3, 0xb4e060, 0x2008)           = 8259

so despite being given a buffer of 8200 bytes, it writes 8259 ...

It happens on several machines and this only seem to happen if there
was a wrap around in the log buffer (it's a first observation on a
limited number of sample so it might be a coincidence)


Cheers,

    Sylvain

PS: Please cc me in any response, I'm not on the list.
