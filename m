Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934275Ab1CYKT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 06:19:28 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:45105 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934188Ab1CYKT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 06:19:26 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: Warning with asm-generic/div64.h
Date: Fri, 25 Mar 2011 18:19:15 +0800
Message-ID: <007801cbead6$1984b6e0$4c8e24a0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Acvq1d4Lywz5vCuITGW7TUpaPYLLHg==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Arnd:

Following warning is generated when using <asm-generic/div64.h>

kernel/power/hibernate.c: In function 'swsusp_show_speed':
kernel/power/hibernate.c:227: warning: comparison of distinct pointer types lacks a cast

After expanding the do_div() macro, the problem line is:

	(void)(((typeof((n)) *)0) == ((uint64_t *)0));

while the type of n is s64.

I am puzzled with the usage of the problem line.

And how to correct it?

Guan Xuetao

