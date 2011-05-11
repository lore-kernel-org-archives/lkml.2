Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab1EKQUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:20:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40659 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab1EKQUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:20:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=XNrBzf/C/6zcmD3dOIpD98RqKxP30zB1trOpOgdyapvuKW2uCPsWiVtgmlap7lD0c6
         Z+xRlipXW2ASx//RDD3k0poScuLB2fnDnIHuEFS599jgJfbeQEmPsrWsVpNPIVPOcmJm
         BJDBCv4dV3iCQvvWc74EZELHIHnEyPGhJPh7g=
MIME-Version: 1.0
In-Reply-To: <20110511132218.GG1661@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <20110510095022.GR1661@htj.dyndns.org> <20110510140620.GB21834@redhat.com>
 <201105102359.58900.vda.linux@googlemail.com> <20110511091955.GD1661@htj.dyndns.org>
 <BANLkTikQm1PVCW3164g0bfgU9fs4MMTfNA@mail.gmail.com> <20110511132218.GG1661@htj.dyndns.org>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Wed, 11 May 2011 12:20:11 -0400
Message-ID: <BANLkTi=mm_rUXcH4Ufq_GdMLnpz4N7B_vg@mail.gmail.com>
Subject: Re: [PATCH 04/11] ptrace: implement PTRACE_INTERRUPT
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Oleg Nesterov <oleg@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 09:22, Tejun Heo <tj@kernel.org> wrote:
> Hey,
>
> On Wed, May 11, 2011 at 02:23:44PM +0200, Denys Vlasenko wrote:
>> I understand this. I am trying to understand what feature are you trying
>> to provide to userland, or what problematic race scenario you are trying
>> to make resolve-able *in userland* by making "stop" and "cont"
>> notifications sticky wrt GETSIGINFO. I just don't see this scenario.
>
> If you still don't see how events can get lost, I'm afraid I can't
> explain any better.  You're repeating that exit_code can record the
> event until it's fetched but it doesn't queue and any trap will
> overwrite it and debuggers don't have to call GETSIGINFO after each
> trap - it only has to do so for signal delivery, group stop and
> INTERRUPT trap.  So, it can just look at the exit_code (which doesn't
> indicate continuation) and let tracee return to userland.
>
> Maybe I'm horribly confused.  Oleg, am I?

If a process issues PTRACE_INTERRUPT, it just wants the target process
to stop. Presumably it doesn't really care _why_, as long as it
doesn't introduce spurious effects visible to the target. As such, if
the process stops on its own due to some other trap, that ought to be
good enough, right? Is there really a need for a trap that will be
reliably echoed back to the trapping process?
