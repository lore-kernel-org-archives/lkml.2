Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1GNASL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 20:18:11 -0400
Received: from ozlabs.org ([203.10.76.45]:54853 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab1GNASJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 20:18:09 -0400
From: Michael Neuling <mikey@neuling.org>
To: Sonny Rao <sonnyrao@chromium.org>
cc: Steven Rostedt <rostedt@goodmis.org>, acme@redhat.com, anton@samba.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] perf: robustify proc and debugfs file recording
In-reply-to: <CAPz6YkW_iHA26+aDBrbiUOKSa_kXuVxO-uiuShHVO89cniS+vw@mail.gmail.com>
References: <1310505348-20163-1-git-send-email-sonnyrao@chromium.org> <29926.1310553581@neuling.org> <30671.1310554369@neuling.org> <1310589536.3931.25.camel@gandalf.stny.rr.com> <CAPz6YkVsnZk0WA+Y-cOTtX4=VQd2=peOyKCD4aHdUXCy3=GDaw@mail.gmail.com> <CAPz6YkW_iHA26+aDBrbiUOKSa_kXuVxO-uiuShHVO89cniS+vw@mail.gmail.com>
Comments: In-reply-to Sonny Rao <sonnyrao@chromium.org>
   message dated "Wed, 13 Jul 2011 13:58:58 -0700."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
Date: Thu, 14 Jul 2011 10:18:05 +1000
Message-ID: <28585.1310602685@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>> +  if (pwrite(output_fd, &size, hdr_sz, hdr_pos) < 0)
> >>
> >> s/&size/sizep/
> >
> > Argh, I'm really messing this up... so yeah this shouldn't have worked
> > on big-endian without that fix..
> > Mikey, are you sure it worked?
> 
> Actually, I think you need to use tracepoints or this code won't be invoked=
> .
> So, please try with some tracepoints, thanks.

Yeah, with tracepoints it's broken.  

With Steven fix though it's all good on my powerpc box.

Mikey
