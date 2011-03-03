Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab1CCBaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 20:30:35 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33571 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790Ab1CCBae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 20:30:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=cxIrI2W6GFv+Api6DWgWnyDpivW2mdT+ylXQejp5Bl48e+jVncPTrvrA1AjJWFkscZ
         x2j4MB4buMrXiPn4uifHzx+/vWWb1Yg1B5ZODPgKGpqJ8fbnRH19OGCNzlrFFDichZRw
         42ZxgePLij9wqusC6n9RBeBFPx+GYvglE+ikw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Indan Zupancic" <indan@nul.nu>
Subject: Re: [RFC] Proposal for ptrace improvements
Date: Thu, 3 Mar 2011 02:30:27 +0100
User-Agent: KMail/1.8.2
Cc: "Oleg Nesterov" <oleg@redhat.com>, "Tejun Heo" <tj@kernel.org>,
        "Roland McGrath" <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org,
        "Michael Kerrisk" <mtk.manpages@googlemail.com>
References: <20110301152457.GE26074@htj.dyndns.org> <20110302133206.GA9838@redhat.com> <0a2c2dfb67198c5bd2cfc6e6c1896f23.squirrel@webmail.greenhost.nl>
In-Reply-To: <0a2c2dfb67198c5bd2cfc6e6c1896f23.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103030230.27363.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 March 2011 01:47, Indan Zupancic wrote:
> On Wed, March 2, 2011 14:32, Oleg Nesterov wrote:
> > On 03/02, Tejun Heo wrote:
> >> On Wed, Mar 02, 2011 at 06:07:35AM +0100, Indan Zupancic wrote:
> >> > I'm not sure what Denys is talking about: Currently it's impossible to
> >> > pass along SIGSTOP to traced processes. Quoting the ptrace manpage:
> >> >
> >> >    PTRACE_CONT
> >> >           Restarts  the stopped child process.  If data is nonzero and not
> >> >           SIGSTOP, it is interpreted as a signal to be  delivered  to  the
> >> >           child;  otherwise,  no  signal is delivered.
> >>
> >> AFAICS, that's not true.  SIGSTOP isn't treated differently from other
> >> signals in the ptrace signal delivery path.  Maybe it was true in the
> >> past.
> >
> > Yes, this is not true. And it seems this was never true.
> >
> > This is the second time this manpage confuses people in this discussion,
> > probably it should be fixed...
> 
> Passing SIGSTOP does not actually stop the traced task, which is in line
> with what the manpage says. All it does is generating that second SIGSTOP
> notification, but when the task is continued it's running, not stopped.

It can be argued that after this the task is running _precisely_
because it was continued by the debugger.

> So ptraced tasks can't be stopped with SIGSTOP and continued with SIGCONT.

It can be stopped - just do not PTRACE_CONT it after second SIGSTOP
notification.

The bug is that it can't be continued with SIGCONT after that.

That's the gist of Tejun Heo's proposal.

Oleg's proposal is a bit different. It proposes that we do need
to do PTRACE_CONT after second SIGSTOP notification too,
but task will be indeed stopped after this, and resumed
when SIGCONT arrives.

-- 
vda
