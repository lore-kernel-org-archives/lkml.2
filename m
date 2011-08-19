Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab1HSUnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 16:43:42 -0400
Received: from mga10.intel.com ([192.55.52.92]:21500 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752187Ab1HSUnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 16:43:41 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Aug 2011 16:43:41 EDT
Subject: Re: [PATCH 2/3] vfork: make it killable
From: Matt Fleming <matt.fleming@intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <20110812175629.GC7484@redhat.com>
References: <20110727163159.GA23785@redhat.com>
	 <20110729192358.GB31717@mtj.dyndns.org> <20110812175550.GA7484@redhat.com>
	 <20110812175629.GC7484@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Fri, 19 Aug 2011 21:33:58 +0100
Message-ID: <1313786038.19751.2.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 19:56 +0200, Oleg Nesterov wrote:
> Make vfork() killable.
> 
> Change do_fork(CLONE_VFORK) to do wait_for_completion_killable().
> If it fails we do not return to the user-mode and never touch ->mm
> shared with our child.
> 
> However, in this case we should clear child->vfork_done before
> return, we use task_lock() in do_fork()->wait_for_vfork_done()
> and complete_vfork_done() to serialize with each other.

It's probably worth updating the comment above task_lock() in
include/linux/sched.h, to say that it is now used to protect
->vfork_done.

