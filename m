Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab2DJRov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 13:44:51 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52589 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab2DJRou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 13:44:50 -0400
Message-ID: <4F84718C.4010706@gmail.com>
Date: Tue, 10 Apr 2012 19:44:44 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] block: Change default IO scheduler to deadline except
 SATA
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:

 > I am wondering if CFQ as default scheduler is still the right choice. CFQ
 > generally works well on slow rotational media (SATA?). But often
 > underperforms on faster storage (storage arrays, PCIE SSDs, virtualized
 > disk in linux guests etc). People often put logic in user space to tune their
 > systems and change IO scheduler to deadline to get better performance on
 > faster storage.
 >
 > Though there is not one good answer for all kind of storage and for all
 > kind of workloads, I am wondering if we can provide a better default and
 > that is change default IO scheduler to "deadline" except SATA.
 >
 > One can argue that some SAS disks can be slow too and benefit from CFQ. Yes,
 > but default IO scheduler choice is not perfect anyway. It just tries to
 > cater to a wide variety of use cases out of the box.
 >
 > So I am throwing this patch out see if it flies. Personally, I think it
 > might turn out to be a more reasonable default.

done time ago for dasd devices.

chuchi:~/curre/linux-2.6 $ grep -ri deadline drivers/s390/block/*
drivers/s390/block/dasd.c:      rc = elevator_init(block->request_queue, "deadline");
drivers/s390/block/Kconfig:     select IOSCHED_DEADLINE
