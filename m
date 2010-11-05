Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0KEQh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 12:37:58 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44132 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab0KEQh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 12:37:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Rm7SoWw8TZUusl97TtIVrUEnIWQL5V4SnrjImP99FpX8Epnb8Zo/jRnh7AiMOGIZjN
         KThoQHzBgxqASvv0YrTF+1dZ9n519X/Szmj5/ZsyUNiyjqXIeqURtb4D6HDK+Ow2/v2h
         z9fTTVqK1HX5gOGi3nGk3aGxfhrQtPxBIN+0Q=
Date: Fri, 5 Nov 2010 19:37:51 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Jan Kiszka <jan.kiszka@web.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Eric Paris <eparis@redhat.com>, Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: BUG: using smp_processor_id() in preemptible
	arch_trigger_all_cpu_backtrace_handler
Message-ID: <20101105163751.GA5678@lenovo>
References: <4CCEB51C.7010901@web.de> <20101101154536.GT4823@redhat.com> <20101101155110.GC5985@lenovo> <AANLkTikVSpw-R6Jt-ZfK6sJXoRv7wJ7-vPHQGcNYkVDK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikVSpw-R6Jt-ZfK6sJXoRv7wJ7-vPHQGcNYkVDK@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 05:06:55PM +0100, Frederic Weisbecker wrote:
> 2010/11/1 Cyrill Gorcunov <gorcunov@gmail.com>:
...
> >  yup, this will do the trick for a while. In general I believe we might have
> > kind of NMI exclusive chain so we wouldn't need the 'case:'s.
> 
> Yeah.  And seperating NMIs from the rest of the DIE notifiers would
> probably improve
> performance of things like PMI handling.
> 

It will make it more straight and clean as minimum which is already
quite a benefit ;) There were patches floating from Don with notify
priorities which are good start. Though I didn't manage to look into
most of patches I've been CC'ed yet :(

> And I've always been confused with this "die" notifier semantic. We
> are not dying when
> we handle a counter overflow interrupt.
> The same applies to DIE_INT3, DIE_TRAP, DIE_DEBUG, ....
> 

As the comment says on top of the enum they are "Grossly misnamed" ;)
Though we could consider them not as "dying" but rather in terms of say
on-die signals (or something like that).

> But until then, as having a seperate notifier is quite a refactoring,
> we should enqueue Don's fix.
> Don, can you resend it with usual SOB and changelog?
> 
> Thanks.
> 
  Cyrill
