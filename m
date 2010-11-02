Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab0KBIzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 04:55:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab0KBIzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 04:55:41 -0400
Date: Tue, 2 Nov 2010 09:55:36 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: prevent SAK to kill init process
Message-ID: <20101102085536.GB1871@jolsa.brq.redhat.com>
References: <1288636466-9775-1-git-send-email-jolsa@redhat.com>
 <m1zktszvba.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zktszvba.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 12:40:41PM -0700, Eric W. Biederman wrote:
> Jiri Olsa <jolsa@redhat.com> writes:
> 
> > hi,
> >
> > hitting "Secure Attention Key" on console that's openned
> > by init process, causing panic due to an attempt to kill
> > the init process.
> >
> > Fixing this by skipping the init process in the loop.
> 
> This sounds like proper behavior.  The goal of SAK is the guarantee that
> no one else has the tty one, and this violates that goal.  Which version
> init opens a controlling tty?  I expect it is time to deliver SIGCLUE
> to it.
I was using some older upstart version, which kept the console open

I found this log entry in changelog :)

       * No longer holds /dev/console open, so the SAK SysRq key will not
         kill Upstart.  (Bug: #486005)

So probably no need for the patch

sry for noise,
jirka
