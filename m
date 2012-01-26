Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab2AZBWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 20:22:52 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45811 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab2AZBWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 20:22:49 -0500
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Jamie Lokier <jamie@shareable.org>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
Date: Thu, 26 Jan 2012 02:22:44 +0100
User-Agent: KMail/1.8.2
Cc: Indan Zupancic <indan@nul.nu>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Andrew Lutomirski <luto@mit.edu>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com> <ca17a86f7c88f8884e4ffc9bafbf2dff.squirrel@webmail.greenhost.nl> <20120126010858.GD18613@jl-vm1.vm.bytemark.co.uk>
In-Reply-To: <20120126010858.GD18613@jl-vm1.vm.bytemark.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201201260222.44225.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 January 2012 02:08, Jamie Lokier wrote:
> Indan Zupancic wrote:
> > > (2) syscall exit compat-ness is known from entry type - no need to indicate it; and
> > > (3) if we would flag syscall entry with an event value in wait status, then syscall
> > > exit will be already distinquisable.
> > 
> > False for execve which messes everything up by changing TID sometimes.
> 
> Is it disambiguated by PTRACE_EVENT_EXEC happening before the execve
> returns, and you knowing the TID always changes to the PID?  I haven't
> yet checked which TID gets the PTRACE_EVENT_EXEC event,

tid change happens before PTRACE_EVENT_EXEC event generation.

-- 
vda
