Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab2DQIE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 04:04:59 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:46442 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab2DQIE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 04:04:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120416143606.2ee7c571@de.ibm.com>
References: <CABWpNyZkL8K3R=ObOvV9SGMVGTcs1R83H0LSWyXFrQ-Wwb5p+w@mail.gmail.com>
 <20120416143606.2ee7c571@de.ibm.com>
From: Bas van der Oest <bassvdo@gmail.com>
Date: Tue, 17 Apr 2012 10:04:35 +0200
Message-ID: <CABWpNyaw3Xq7FJ4A0itYEFLN1QdwBvvqs0rVxB1z-cyaUcmuVw@mail.gmail.com>
Subject: Re: /proc/stat information incorrect
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Assuming that you are on a recent kernel (>= 3.2), could you please
> try to revoke git commit a25cac5198d4ff28 "proc: Consider NO_HZ when
> printing idle and iowait times" and try again ?

I revoked the patch and this certainly had effect, however I still
doubt if the result is completely correct now.
It now seems that CPU4 (this one is handling the irqs now) spends more
time than the other CPUs:

        user    nice    system  idle    iowait  irq   softirq sum
cpu     4       0       412     8186    0       0       79      8681
cpu0    0       0       1       1074    0       0       1       1076
cpu1    0       0       2       1075    0       0       0       1077
cpu2    0       0       1       1075    0       0       0       1076
cpu3    0       0       1       1079    0       0       0       1080
cpu4    1       0       115     941     0       0       78      1135
cpu5    2       0       99      984     0       0       0       1085
cpu6    0       0       98      977     0       0       0       1075
cpu7    0       0       95      980     0       0       0       1075

Any suggestions where this small difference is coming from?
