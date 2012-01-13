Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab2AMJg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 04:36:56 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46655 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab2AMJgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 04:36:54 -0500
MIME-Version: 1.0
In-Reply-To: <1326443147-26645-1-git-send-email-qiang.liu@freescale.com>
References: <1326443147-26645-1-git-send-email-qiang.liu@freescale.com>
Date: Fri, 13 Jan 2012 17:36:52 +0800
X-Google-Sender-Auth: zJxmhYeg5M_6m8NOaa14VQ_APso
Message-ID: <CADRPPNQsVB-2jR0UaX6RB_4PCf9kt4UXvAXnxaVk=LsBcwGowg@mail.gmail.com>
Subject: Re: [PATCH][SDK v1.2] sata: I/O load balancing
From: Li Yang <leoli@freescale.com>
To: Qiang Liu <qiang.liu@freescale.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Qiang Liu <b32616@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 4:25 PM, Qiang Liu <qiang.liu@freescale.com> wrote:
> From: Qiang Liu <b32616@freescale.com>
>
> Reduce interrupt singnals through reset Interrupt Coalescing Control Reg.
> Increase the threshold value of interrupt and timer will reduce the number
> of complete interrupt sharply. Improve the system performance effectively.

There is always a trade off of throughput and latency by using
interrupt coalescing.  It's not reasonable to assume that the
throughput is the only factor to be considered and set the coalescing
threshold and timeout to the max value by default.  Have you carried
out other benchmark like copying many small files?

It will be safer to make the coalescing runtime configurable like the
sata_mv driver, IMO.

- Leo
