Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491Ab1ELSew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:34:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab1ELSeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:34:50 -0400
Date: Thu, 12 May 2011 20:33:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 09/11] job control: reorganize wait_task_stopped()
Message-ID: <20110512183326.GA26042@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-10-git-send-email-tj@kernel.org> <20110511154854.GB23688@redhat.com> <20110511192902.GC24245@mtj.dyndns.org> <20110512154247.GC18599@redhat.com> <20110512160253.GK1030@htj.dyndns.org> <20110512172506.GA23033@redhat.com> <20110512173228.GO1030@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512173228.GO1030@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12, Tejun Heo wrote:
>
>   int main(int argc, char **argv)
>   {
> 	  pid_t child, control;
>
> 	  child = fork();
> 	  if (!child)
> 		  while (1)
> 			  pause();
>
> 	  kill(child, SIGSTOP);
> 	  waitid(P_PID, child, NULL, WSTOPPED | WNOWAIT);
>
> 	  control = fork();
> 	  if (!control) {
> 		  while (1) {
> 			  kill(child, SIGCONT);
> 			  nanosleep(&ts1ms, NULL);
> 			  kill(child, SIGSTOP);
> 			  nanosleep(&ts1ms, NULL);

Damn, you are right, I think.

At first glance, do_wait() does

	wait_task_stopped();
	wait_task_continued();

and the state can be changed CONTINIUED -> STOPPED in between, right?
Or something else?

Thanks, for the explanation.

Oleg.

