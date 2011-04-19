Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab1DSOfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:35:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60476 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab1DSOfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:35:51 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=wom5GMh1gUkA:10 a=n9MmX0RCC_8A:10 a=Rj1_iGo3bfgA:10 a=8nJEP1OIZ-IA:10 a=eAWTIsOZi86Vnn5xZOjC/w==:17 a=pGLkceISAAAA:8 a=hBqU3vQJAAAA:8 a=CZ2Bs_yQ-uKZIu-BEzYA:9 a=wPNLvfGTeEIA:10 a=MSl-tDqOz04A:10 a=4gZ4WExUoD4A:10 a=eAWTIsOZi86Vnn5xZOjC/w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.154.172
Date: Tue, 19 Apr 2011 09:35:48 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: crocket <crockabiscuit@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Andrew Morgan <morgan@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux capabilities shouldn't be lost during setuid to non-root
 from root or to another non-root uid from a non-root uid.
Message-ID: <20110419143548.GA26461@hallyn.com>
References: <BANLkTikTxCFHs2xb4b5QFQp3SJAEjgyRJg@mail.gmail.com>
 <20110417180722.GA21112@hallyn.com>
 <BANLkTinumLPEsstxP9px9=K23SUR9e2aRw@mail.gmail.com>
 <20110418082838.GA30088@hallyn.com>
 <BANLkTi=kxpFkQ86ZGd2_q+XFRm-nVWzw4g@mail.gmail.com>
 <20110418220232.GA15967@hallyn.com>
 <BANLkTikJqgwGixtgXKOY-2e=1sAQYUtbcQ@mail.gmail.com>
 <BANLkTimELd0WhNYkaQOQuV1vnr+5jAgTZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimELd0WhNYkaQOQuV1vnr+5jAgTZA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting crocket (crockabiscuit@gmail.com):
> Thanks for the precious information.
> 
> I think capsh should be introduced somewhere in some manuals.

Would mentioning capsh in capabilities(7) be a good idea?

> On Tue, Apr 19, 2011 at 10:14 AM, crocket <crockabiscuit@gmail.com> wrote:
> > Is there an existing utility that sets SECBIT_NO_SETUID_FIXUP?
> > Or is there a way to set it without writing a C wrapper program?
> >
> > On Tue, Apr 19, 2011 at 7:02 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> >> Quoting crocket (crockabiscuit@gmail.com):
> >>> I have several questions.
> >>>
> >>> 1) How do I set SECBIT_NO_SETUID_FIXUP?
> >>
> >> prctl(PR_SET_SECUREBITS, SECBIT_NO_SETUID_FIXUP | SECBIT_NO_SETUID_FIXUP_LOCKED)
> >>
> >> see capabilities(7) for details.
> >>
> >>> 2) Is there any reason to unset SECBIT_NO_SETUID_FIXUP by default?
> >>
> >> Yes, because it's what userspace expects.  If you prefer to run in
> >> a full POSIX capabilities environment with unprivileged root, you
> >> can have init set SECBIT_NO_SETUID_FIXUP and SECBIT_NOROOT and
> >> tune userspace to do the right thing, but it's not trivial.
> >>
> >> -serge
> >>
> >
