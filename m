Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab2DYHYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 03:24:33 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:55286 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2DYHYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 03:24:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120420140654.793a40f2@de.ibm.com>
References: <CABWpNyZkL8K3R=ObOvV9SGMVGTcs1R83H0LSWyXFrQ-Wwb5p+w@mail.gmail.com>
 <20120416143606.2ee7c571@de.ibm.com> <CABWpNyaw3Xq7FJ4A0itYEFLN1QdwBvvqs0rVxB1z-cyaUcmuVw@mail.gmail.com>
 <20120420140654.793a40f2@de.ibm.com>
From: Bas van der Oest <bassvdo@gmail.com>
Date: Wed, 25 Apr 2012 09:24:11 +0200
Message-ID: <CABWpNyYYN11dG8Pxv3xZRAy7go3V4UpMcWcyWCEcqBcBaW8pGw@mail.gmail.com>
Subject: Re: /proc/stat information incorrect
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your consideration Martin.
> CONFIG_IRQ_TIME_ACCOUNTING comes to mind. Is this enabled for your
> kernel ?

This configuration was not yet enabled.
I tried this configuration with and without the patch you mentioned
(git a25cac5198d4ff28).
The results are still not completely as expected:

With patch, with CONFIG_IRQ_TIME_ACCOUNTING:
        user    nice    system  idle    iowait  irq     softirq sum
cpu     5       0       373     7610    0       55      382     8425
cpu0    0       0       1       1042    0       18      1       1062
cpu1    0       0       1       1058    0       1       0       1060
cpu2    0       0       1       1060    0       0       0       1061
cpu3    0       0       0       1061    0       1       0       1062
cpu4    2       0       75      505     0       36      380     998
cpu5    1       0       82      983     0       0       0       1066
cpu6    1       0       139     911     0       0       0       1051
cpu7    1       0       74      988     0       0       0       1063

Revoked patch and CONFIG_IRQ_TIME_ACCOUNTING:
        user    nice    system  idle    iowait  irq     softirq sum
cpu     8       0       461     7854    0       55      448     8826
cpu0    0       0       1       1056    0       15      1       1073
cpu1    0       0       1       1073    0       0       1       1075
cpu2    1       0       1       1073    0       0       0       1075
cpu3    0       0       1       1217    0       0       1       1219
cpu4    3       0       147     511     0       39      447     1147
cpu5    1       0       106     967     0       0       0       1074
cpu6    1       0       99      972     0       0       0       1072
cpu7    1       0       106     985     0       1       1       1094

Looking at the sum column still some unexpected behaviour is seen.
The CONFIG_IRQ_TIME_ACCOUNTING  seems to help but the interrupt
handling CPU (CPU4) is still "lazy" when the original code is used
(with patch).
If the patch is revoked some other CPUs seem to spend more time than
is really available.
Both scenarios should not be possible imho.
