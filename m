Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab1J3UDn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 16:03:43 -0400
Received: from smtprelay0177.b.hostedemail.com ([64.98.42.177]:40343 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750868Ab1J3UDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 16:03:42 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Oct 2011 16:03:42 EDT
X-Panda: scanned!
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 2206
Date: Sun, 30 Oct 2011 19:57:12 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: linux-kernel@vger.kernel.org
Message-ID: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
Subject: HT (Hyper Threading) aware process scheduling doesn't work as it
 should
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.147.51.36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

It's known that if you want to reach maximum performance on HT enabled Intel CPUs you
should distribute the load evenly between physical cores, and when you have loaded all
of them you should then load the remaining virtual cores.

For example, if you have 4 physical cores and 8 virtual CPUs then if you have just four
tasks consuming 100% of CPU time you should load four CPU pairs:

VCPUs: {1,2} - one task running

VCPUs: {3,4} - one task running

VCPUs: {5,6} - one task running

VCPUs: {7,8} - one task running

It's absolutely detrimental to performance to bind two tasks to e.g. two physical cores
{1,2} {3,4} and then the remaining two tasks to e.g. the third core 5,6:

VCPUs: {1,2} - one task running

VCPUs: {3,4} - one task running

VCPUs: {5,6} - *two* task runnings

VCPUs: {7,8} - no tasks running

I've found out that even on Linux 3.0.8 the process scheduler doesn't correctly distributes
the load amongst virtual CPUs. E.g. on a 4-core system (8 total virtual CPUs) the process
scheduler often run some instances of four different tasks on the same physical CPU.

Maybe I shouldn't trust top/htop output on this matter but the same test carried out on
Microsoft XP OS shows that it indeed distributes the load correctly, running tasks on different
physical cores whenever possible.

Any thoughts? comments? I think this is quite a serious problem.

Best wishes,

Artem
