Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab2DEAx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 20:53:27 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33973 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2DEAx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 20:53:26 -0400
MIME-Version: 1.0
Date: Wed, 4 Apr 2012 20:53:25 -0400
Message-ID: <CADEOusebxthJy3s7oCpujXL+KHkFVGH=19psFX2T2B88BOacEQ@mail.gmail.com>
Subject: CPU Load Balancer / Scheduler / CFS
From: Robert W <robertwalters83@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing some bizarre differences between two servers (one running
2.6.32 and the other 2.6.18) with how processes are spread across
CPUs.

I created a simple test client: https://gist.github.com/2306761
which forks 4 times to create processes which just consume cpu.

On 2.6.18, the processes are distributed across CPUs as expected (all
4 processes are consuming 100%).
But on 2.6.32, the distribution varies. Sometimes it's (100%, 33%,
33%, 33%), other times it's (100%, 100%, 50%, 50%), etc.. while all
the other CPUs sit completely idle..

Both servers have many cores (more than 4). Both servers each have 2
physical processors, and are hyper-threaded.

What could be going on here?
