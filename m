Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788Ab2JZPWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:22:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933630Ab2JZPWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:22:24 -0400
Date: Fri, 26 Oct 2012 17:23:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: mark_files_ro && sb_end_write
Message-ID: <20121026152312.GA13725@redhat.com>
References: <1350650286.30157.28.camel@twins> <Pine.LNX.4.64.1210191058060.13298@file.rdu.redhat.com> <1350668451.2768.60.camel@twins> <Pine.LNX.4.64.1210191758570.12753@file.rdu.redhat.com> <20121024030845.GT4291@dastard> <Pine.LNX.4.64.1210251008330.1849@file.rdu.redhat.com> <20121025234048.GH29378@dastard> <20121026120605.GA23545@redhat.com> <Pine.LNX.4.64.1210260900170.24474@file.rdu.redhat.com> <20121026141238.GA28443@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121026141238.GA28443@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26, Oleg Nesterov wrote:
>
> As for the changing fs/namespace.c to use percpu_rwsem, I am not sure
> it is that simple and even worthwhile but I won't argue, I do not
> pretend I understand this code.

BTW, speaking about these counters...

Is mark_files_ro()->mnt_drop_write_file() properly balanced?
__mnt_drop_write() looks fine, but sb_end_write?

Oleg.

