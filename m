Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab1GUVOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:14:33 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55250 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab1GUVOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 17:14:32 -0400
MIME-Version: 1.0
From: Ganesh Karuppur Rajagopalan <ganesh.kr356@gmail.com>
Date: Thu, 21 Jul 2011 17:13:52 -0400
Message-ID: <CAFXDVL-S=1ojQ2MngF0yVNSxdPzqh5un95jGkpXCLFU03WVHOw@mail.gmail.com>
Subject: Stopping a kthread in module exit(system hangs!) - linux 2.6.39.1
To: linux-kernel@vger.kernel.org
Cc: Pallav Bose <pallavbose@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,


The kernel version we are  using is 2.6.39.1 . In our block device
driver module we create and run a kthread using "kthread_run" during
module_init.This kthread runs until we issue a "kthread_stop" from the
module_exit code.In the thread function we repeatedly check for
"kthread_should_stop" and when the condition is met (due to the
kthread_stop call) we "return 0;". Our thread function wouldn't return
 in any other scenario.

Our problem right now is that when we do an "rmmod" the system just
hangs!.This we have identified is due to the kthread_stop. Can you
please give us some pointers/directions regarding the possible
underlying issue.Specifically is there a problem while calling
kthread_stop and waiting on the thread completion in the module exit
code.


Thanks and Regards
Ganesh
