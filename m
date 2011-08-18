Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab1HRJpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 05:45:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215Ab1HRJpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 05:45:50 -0400
Message-ID: <4E4CDF44.5080109@redhat.com>
Date: Thu, 18 Aug 2011 11:45:40 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: device-mapper development <dm-devel@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: clone() with CLONE_NEWNET breaks kobject_uevent_env()
X-Enigmail-Version: 1.2.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after analysing very strange report (with running chromium
some device-mapper ioctl functions started to fail) I found
interesting problem:

If you run clone() with CLONE_NEWNET (which is chromium using
for sanboxing), udev namespace is cloned too (newly registered
in uevent_sock_list) and netlink send (except the first in list)
fails with -ESRCH.

This causes that _every_ call of kobject_uevent_env() return failure.

Most of users silently ignores  kobject_uevent() return value,
so the problem was invisible for long time.

Unfortunately dm checks return value and reports failure,
taking the wrong error path.

How is this supposed to work?

Why cloning net namespace breaks the udev netlink subsystem?

Is it bug or we need to do something differently?
(I do not think ignoring return value is the proper way...)

Thanks,
Milan
