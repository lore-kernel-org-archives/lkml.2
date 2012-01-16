Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab2APEsf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 23:48:35 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62605 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab2APEsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 23:48:32 -0500
MIME-Version: 1.0
From: Prateek Sharma <prateek3.14@gmail.com>
Date: Mon, 16 Jan 2012 10:18:10 +0530
Message-ID: <CAKwxwqwM0usOqvbu8ZaG6=SXS6tjQXqtrGjXnbEUMuqZaUs8Sg@mail.gmail.com>
Subject: High sleep_on_page latency
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
  I am measuring system latency using latencytop. I am using kernel
version 3.0 with some minor changes.
The latencytop output for the process doing the IO (qemu) is below:

Process qemu-system-x86 (6239)             Total: 31363.7 msec
[sleep_on_page]                                   1966.5 msec         81.4 %
Waiting for event (select)                          5.0 msec          7.8 %
[kvm_vcpu_block]                                    5.0 msec          8.5 %
synchronous write                                   1.7 msec          0.0 %
Userspace lock contention                           1.5 msec          2.3 %

Is the 2000 msec sleep_on_page delays normal ? I would also like to
know what sleep_on_page exactly corresponds to. My understanding is
that it is the time spent waiting for grabbing a lock on a page. Is
this correct ?

Thanks.
