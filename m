Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab2AaErb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 23:47:31 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:38829 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753870Ab2AaEra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 23:47:30 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/GXlpuv4XGbg/oDC+kc3Mkyn4P+qXGfoRuYbqnv3
	EWoMblslId9RD5
Message-ID: <1327985246.6667.8.camel@marge.simson.net>
Subject: Re: isolcpus question
From: Mike Galbraith <efault@gmx.de>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 31 Jan 2012 05:47:26 +0100
In-Reply-To: <201201302213.39672.gene.heskett@gmail.com>
References: <201201302213.39672.gene.heskett@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 22:13 -0500, Gene Heskett wrote:
> Which is, is there a isolcpus troubleshooting tool?
> 
> I have an app that is supposed to use the 2nd cpu on a 2 core atom system 
> all by itself, and its insisting on using cpu0 when the boot command line 
> has "isolcpus=1" appended to it, and apparently I am the only one with the 
> problem, its working for about 200-500 others running the same software.

isolcpus=1 isolates CPU1 so no task will automatically end up using it,
but it's up to your task (or you) to move to the isolated CPU.  Pin your
task to CPU1 with taskset, and all should work fine.

	-Mike

