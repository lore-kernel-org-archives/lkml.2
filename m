Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab1HUSwe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 14:52:34 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34740 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1HUSwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 14:52:30 -0400
Message-ID: <4E5153D8.7010607@gmail.com>
Date: Sun, 21 Aug 2011 11:52:08 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        akinobu.mita@gmail.com
Subject: module param for CPU_NOTIFIER_ERROR_INJECT
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,
I am playing around with CPU_NOTIFIER_ERROR_INJECT and am noticing that

example 2
# modprobe cpu-notifier-error-inject cpu_up_prepare_error=-2
# echo 1 > /sys/devices/system/cpu/cpu1/online
bash: echo: write error: No such file or directory

is not working for me, or atleast is not showing me any info that it is 
working.

the other proceedure does work:

example 1
# modprobe cpu-notifier-error-inject cpu_down_prepare_error=-1
# echo 0 > /sys/devices/system/cpu/cpu1/online
bash: echo: write error: Operation not permitted

dmesg shows:
[ 2427.924405] Injecting error (-1) at cpu notifier
[ 2427.930569] _cpu_down: attempt to take down CPU 1 failed


any ideas on what I need to do or is this working, and am I not seeing 
anything in dmesg?

Justin P. Mattock
