Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab0FTV6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 17:58:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519Ab0FTV6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 17:58:35 -0400
Date: Sun, 20 Jun 2010 23:56:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 0/6] Unshare support for the pid namespace.
Message-ID: <20100620215646.GB17517@redhat.com>
References: <20100618082033.GD16877@hawkmoon.kerlabs.com> <20100618111554.GA3252@redhat.com> <20100618160849.GA7404@redhat.com> <20100618173320.GG16877@hawkmoon.kerlabs.com> <20100618175541.GA13680@redhat.com> <20100618212355.GA29478@redhat.com> <20100619190840.GA3424@redhat.com> <m1pqzmqema.fsf_-_@fess.ebiederm.org> <20100620180335.GA17120@redhat.com> <m14ogxctd6.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14ogxctd6.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > And. I do not think these series can fix the discussed problems. ns->dead
> > definitely can't, no?
>
> I'm am fairly confident that we have the signal sending races fixed so
> we can reasonably expect having sent SIGKILL to all processes in a pid
> namespace

Sorry, didn't notice this part...

Which races? I am talking about the current problems with pid_ns_release_proc(),
we have at least 3 bugs, from the 2/2 changelog:

	- Nobody does mntput() if copy_process() fails after
	  pid_ns_prepare_proc().

	- proc_flush_task() checks upid->nr == 1 to verify we are init,
	  this is wrong if a multi-threaded init does exec.

	- As Louis pointed out, this namespace can have the detached
	  EXIT_DEAD tasks which can use ns->proc_mnt after this mntput().

Oleg.

