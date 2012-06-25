Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab2FYGEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 02:04:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58070 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab2FYGEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 02:04:05 -0400
Date: Mon, 25 Jun 2012 07:03:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: deferring __fput()
Message-ID: <20120625060357.GT14083@ZenIV.linux.org.uk>
References: <1340369098.2464.20.camel@falcor>
 <20120623092049.GH14083@ZenIV.linux.org.uk>
 <20120623194505.GI14083@ZenIV.linux.org.uk>
 <20120623203800.GA10306@redhat.com>
 <20120623210141.GK14083@ZenIV.linux.org.uk>
 <20120624041652.GN14083@ZenIV.linux.org.uk>
 <20120624153310.GB24596@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120624153310.GB24596@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2012 at 05:33:10PM +0200, Oleg Nesterov wrote:
> No, we can't do this?
> 
> OK, perhaps we can check something else instead of PF_EXITING.
> But somehow we should ensuree that if task_work_add(twork) succeeds,
> then twork->func() will be called. IOW, if task_work_add() races with
> the exiting task, it should not succeed after exit_task_work().

Hrm...  I still think that callers can bloody well check it themselves,
but anyway - we can add a new PF_... bit and have it set on kernel threads
(all along) and during exit_task_work(); the real question is in locking
and barriers needed there.  Suggestions?
