Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab1CWRSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:18:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845Ab1CWRSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:18:45 -0400
Date: Wed, 23 Mar 2011 18:09:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 1/8] job control: Don't set group_stop exit_code if
	re-entering job control stop
Message-ID: <20110323170920.GB24304@redhat.com>
References: <1299614199-25142-1-git-send-email-tj@kernel.org> <1299614199-25142-2-git-send-email-tj@kernel.org> <20110321132024.GA18777@redhat.com> <20110321155250.GE12003@htj.dyndns.org> <20110322184415.GA28038@redhat.com> <20110323084421.GW12003@htj.dyndns.org> <20110323164014.GA22527@redhat.com> <20110323170236.GF12003@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323170236.GF12003@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23, Tejun Heo wrote:
>
> Hey,
>
> On Wed, Mar 23, 2011 at 05:40:14PM +0100, Oleg Nesterov wrote:
> > > Hmmm... There are two competing signals in that case - SIGTTIN sent by
> > > the parent and SIGSTOP sent by someone else.
> >
> > "someone else" can be PTRACE_CONT(SIGSTOP) from the debugger.
>
> The debugger should be doing PTRACE_CONT(notified_signo).

Why? it can change the signal.

> Am I
> missing something?  Anyways, this doesn't really matter. I kinda like
> just testing STOP_STOPPED both in stop initiation and notification
> paths but well it's no biggie either way.

OK, agreed, please forget.

Oleg.

