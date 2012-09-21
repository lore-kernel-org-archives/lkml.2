Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab2IUT2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:28:05 -0400
Received: from 217-155-41-104.dsl.in-addr.zen.co.uk ([217.155.41.104]:46406
	"EHLO centos1.newflow.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752497Ab2IUT2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:28:02 -0400
Message-ID: <505CBFAA.3080604@mimc.co.uk>
Date: Fri, 21 Sep 2012 20:27:38 +0100
From: Mark Jackson <mpfj-list@mimc.co.uk>
Organization: Mercury HMI Ltd
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: linux-omap@vger.kernel.org
CC: lkml <linux-kernel@vger.kernel.org>
Subject: gpmc_cs_request() causes early boot hang
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm developing a beaglebone cape board which requires the use of a GPMC 
chip select.

I've chosen GPMC_CS0, and in board-am335xevm.c, I have added the following:-

static void gpmc_test()
{
     unsigned long base = 0x12345678;
     gpmc_cs_request(0, SZ_16M, &base);
     printk(KERN_INFO "gpmc base @ 0x%08lx\n", base);
}

... and added a call to gpmc_test() at the end of am335x_evm_init().

If I try to run this code, the kernel fails to boot, and simply hangs at:-

Uncompressing Linux... done, booting the kernel.

If I comment out the call to gpmc_cs_request(), the system boots as 
expected (but without my required cs).

I've looked at the use of this call in other board files, and can't see 
that their code does anything special so I'm stuck on why this simple 
code fails to work.

Can anyone shed light on what I'm doing wrong ?

Do I have to initialise the gpmc beforehand in some way ?

Cheers
Mark JACKSON

