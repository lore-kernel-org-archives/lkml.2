Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab0C3KiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 06:38:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52953 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab0C3KiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 06:38:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 4/6] procfs: Use generic_file_llseek in /proc/vmcore
Date: Tue, 30 Mar 2010 11:38:18 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <1269930015-863-5-git-send-regression-fweisbec@gmail.com>
In-Reply-To: <1269930015-863-5-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003301238.18429.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19T1+iQlUoi1UF7VOjVlz3OPKK96BcNyfdI8Yx
 4jhST0DeC9HZzBsP6L5R/FLvkowl8H0I9GARGRVEHwxy0kHKoC
 JqrYHdavCjBoR24c+ETdg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 March 2010, Frederic Weisbecker wrote:
> /proc/vmcore has no llseek and then falls down to use default_llseek.
> This is racy against read_vmcore() that directly manipulates fpos
> but it doesn't hold the bkl there so using it in llseek doesn't
> protect anything.
> 
> Let's use generic_file_llseek() instead.
> 
Acked-by: Arnd Bergmann <arnd@arndb.de>
