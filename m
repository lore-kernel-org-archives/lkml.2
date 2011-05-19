Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934476Ab1ESTiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:38:20 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:49268 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933830Ab1ESTiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:38:18 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 May 2011 15:38:18 EDT
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Date: Thu, 19 May 2011 20:31:33 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-28-generic; KDE/4.6.2; x86_64; ; )
Cc: Denys Vlasenko <vda.linux@googlemail.com>, oleg@redhat.com,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <20110518095539.GU20624@htj.dyndns.org> <20110519141728.GJ627@htj.dyndns.org>
In-Reply-To: <20110519141728.GJ627@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105192031.33569.pedro@codesourcery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 May 2011 15:17:28, Tejun Heo wrote:
> But making SEIZE not trigger INTERRUPT and SETOPTIONS without
> requiring TRACED don't seem too difficult.  Jan, would that be enough?
> Oleg, what do you think?

UUIC, that opens a race where between SEIZEing and
SETOPTIONS(O_TRACE FORK|VFORK|EXEC...), the tracee can
fork/vfork/clone/exec, without the tracer getting the
nice corresponding PTRACE_EVENT_ events.

In GDBs case, GDB will want to poke at memory
right after attaching, to at least read the
loaded DSO list, so if you can't read tracee
memory without interrupting it, you won't get much
benefit from SEIZE not interrupting.
Not to say other users wouldn't benefit.

-- 
Pedro Alves
