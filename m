Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab0IOJtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 05:49:19 -0400
Received: from smarthost01.mail.zen.net.uk ([212.23.3.140]:44705 "EHLO
	smarthost01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294Ab0IOJtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 05:49:18 -0400
Message-ID: <4C909696.5000503@cyconix.com>
Date: Wed, 15 Sep 2010 10:49:10 +0100
From: Evan Lavelle <sa212+lkml@cyconix.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Driver crash when changing a function from external to internal linkage
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost01-IP: [82.70.243.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an ISR which schedules a tasklet to handle an interrupt.

The tasklet is function A, which calls function B, which calls function C.

When all of A, B, and C have extern linkage, there's no problem. 
However, when B is declared static, the driver crashes, and hangs up the 
machine. The driver only crashes if C contains any code; if it's just an 
empty function then there's no problem.

Any thoughts on what the problem is here? This is x86_32/PAE, 
2.6.18-53.el5PAE, gcc 4.1.2 (Red Hat 4.1.2-46).

Thanks -

Evan
