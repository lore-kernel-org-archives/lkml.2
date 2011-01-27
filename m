Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab1A0Vtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 16:49:41 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:44456 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab1A0Vtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 16:49:40 -0500
Message-ID: <4D41E86D.8060205@free.fr>
Date: Thu, 27 Jan 2011 22:49:33 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <kees.cook@canonical.com>
Subject: [BUG] broken ebba638ae723d8a8fc2f7abce5ec18b688b791d7
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

ebba638ae723d8a8fc2f7abce5ec18b688b791d7 x86, cpu: Call verify_cpu during 32bit CPU startup look buggy.

It add a call to verify_cpu, but we never set the stack before (I check with qemu + gdbserver that sp is random
when doing cpu hotplug).
This mean do randomly corrupt the memory.

Matthieu
