Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab0KMSZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 13:25:28 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:57250 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab0KMSZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 13:25:26 -0500
Subject: Re: [PATCH] Fix dmesg_restrict build failure with
 CONFIG_EMBEDDED=y and CONFIG_PRINTK=n
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Eugene Teo <eugeneteo@kernel.org>,
        Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com>
References: <1289669176.16461.12.camel@Joe-Laptop>
	 <AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Nov 2010 13:25:21 -0500
Message-ID: <1289672721.3090.349.camel@Dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Anyway, suggested replacement patch attached. Comments?
> 

The desired behavior was to allow a reader with CAP_SYS_ADMIN to open
the syslog via /proc/kmsg and continue reading it even after dropping
capabilities, which is why it was placed where it was.  I see no problem
with moving it back out to do_syslog, but ideally the same behavior
should be replicated.

-Dan

