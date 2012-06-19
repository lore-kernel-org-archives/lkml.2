Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab2FSBjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 21:39:09 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57967 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab2FSBjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 21:39:07 -0400
MIME-Version: 1.0
Date: Tue, 19 Jun 2012 09:39:05 +0800
Message-ID: <CAK9wHMQ7ZLtMTfBKWOb4A8wmjP9EQV8gA_moh5dXxvU0-b-vMQ@mail.gmail.com>
Subject: pm runtime and system suspend resume
From: chao xie <xiechao.linux@gmail.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        pavel@ucw.cz, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi
PM_RUNTIME provide a way for device driver do runtime PM. so for some
devices, they have some surrounded logic. For example, the device may
get clock from outside, or it need PHY support(USB is a example).
To get these dependency out of device driver, i define a struct
dev_pm_domain, and make dev.pm_domain point to it. So in the device
driver, when the hardware should be enabled, we can call
pm_runtime_get_sync while when the hardware is idle or does not work,
we can call pm_runtime_put_sync.
It seems work well, but i have question about the suspend/resume of
device. When the whole system will go to deep idle, and it will
suspend the devices. for the function do device suspend
__device_suspend, it will call pm_runtime_get_noresume(dev). As i
think it will make the device not do runtime suspend any more. Is that
correct?
There is the question, how device driver handle the logic surrounds
it? I want to add pm_runtime_put_sync in dev->driver->pm->suspend
function, and pm_runtime_get_sync in dev->driver->pm->resume. Because
__device_suspend increase the usage_count, pm_runtime_put_sync will
not do real work.
So is that right that i directly call pm_runtime_suspend in
dev->driver->pm->suspend and pm_runtime_resume in
dev->driver->pm->resume?
Thanks.
