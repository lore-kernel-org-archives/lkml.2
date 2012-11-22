Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab2KVV0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:26:16 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33424 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab2KVV0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:26:11 -0500
MIME-Version: 1.0
In-Reply-To: <50AE0210.7010301@jan-o-sch.net>
References: <50AE0210.7010301@jan-o-sch.net>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 22 Nov 2012 13:29:00 +0100
Message-ID: <CAPXgP13OyV-hT=D_-rOyuk2_4n1deQ57ZdRvooBS5Z=sHM_HuQ@mail.gmail.com>
Subject: Re: /proc/kmsg giving eof on blocking read
To: Jan Schmidt <list.lkml@jan-o-sch.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 11:44 AM, Jan Schmidt <list.lkml@jan-o-sch.net> wrote:
> I'm currently debugging something in btrfs in good old printk style, generating
> around 10MB/min. I'm seeing /proc/kmsg returning eof on a blocking read (and,
> side note, syslog-ng won't reopen it, effectively stopping logging kernel
> messages silently).

Are you sure there is not something else that opens the same file?
Even once might be enough to return 0. The too simple locking logic in
/proc/kmsg cannot support multiple readers properly, it never did.

Kay
