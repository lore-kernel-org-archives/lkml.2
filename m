Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab2JODqy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 23:46:54 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:15140 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2JODqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 23:46:52 -0400
From: "Yangfei (Felix)" <felix.yang@huawei.com>
To: "linux-assembly@vger.kernel.org" <linux-assembly@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Hardcoded instruction causes certain features to fail on ARM
 platfrom due to endianness
Thread-Topic: Hardcoded instruction causes certain features to fail on ARM
 platfrom due to endianness
Thread-Index: Ac2qh4xbYCm2qA8uSCiJR4GBLTZbOg==
Date: Mon, 15 Oct 2012 03:46:47 +0000
Message-ID: <DA41BE1DDCA941489001C7FBD7A8820E3CB407A4@szxeml549-mbx.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.135.72.226]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

    I found that hardcoded instruction in inline asm can cause certains certain features fail to work on ARM platform due to endianness.
    As an example, consider the following code snippet of platform_do_lowpower function from arch/arm/mach-realview/hotplug.c:
                / *
                 * here's the WFI
                 */
                asm(".word      0xe320f003\n"
                    :
                    :
                    : "memory", "cc");

    The instruction generated from this inline asm will not work on big-endian ARM platform, such as ARM BE-8 format. Instead, an exception will be generated.

    Here the code should be:
                / *
                 * here's the WFI
                 */
                asm("WFI\n"
                    :
                    :
                    : "memory", "cc");

    Seems the kernel doesn't support ARM BE-8 well. I don't know why this problem happens.
    Can anyone tell me who owns this part? I can prepare a patch then. 
    Thanks.
