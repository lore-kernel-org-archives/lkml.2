Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab0CQVuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 17:50:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab0CQVum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 17:50:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Veaceslav Falico <vfalico@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] signal_struct->count must die, initial changes
In-Reply-To: Oleg Nesterov's message of  Wednesday, 17 March 2010 20:28:47 +0100 <20100317192847.GA2086@redhat.com>
References: <20100317192847.GA2086@redhat.com>
X-Shopping-List: (1) Vigorous L'eggs
   (2) Hydraulic clothes
   (3) Arab-Israeli Geese
Message-Id: <20100317215033.867F9BD1A@magilla.sf.frob.com>
Date: Wed, 17 Mar 2010 14:50:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> signal_struct->count in its current form must die.

Agreed.  This series
Acked-by: Roland McGrath <roland@redhat.com>

> 	- otoh, we really need to make task->signal refcountable,
> 	  just look at the extremely ugly task_rq_unlock_wait()
> 	  called from __exit_signals().

Another of many good reasons for...

> 	- we should change the lifetime rules for task->signal,
> 	  it should be pinned to task_struct. We have a lot of
> 	  code which can be simplified after that.

Yes, and sighand too.  I think there will be quite a torrent of cleanup we
can do after that.

Remember too that we should really change de_thread() altogether.  It has
long-standing signal-losing races that we should fix.  Changing the
lifetime rules may complicate that, or not.  But they'll tie in together,
and when we do that we'll replace the notify_count again with something
else entirely.


Thanks,
Roland
