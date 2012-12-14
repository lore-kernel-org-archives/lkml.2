Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945986Ab2LNXKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:10:36 -0500
Received: from www84.your-server.de ([213.133.104.84]:50892 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945905Ab2LNXKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:10:33 -0500
Message-ID: <1355526568.758.5.camel@wall-e>
Subject: Re: [CRIU] [PATCH] Add VDSO time function support for x86 32-bit
 kernel
From: Stefani Seibold <stefani@seibold.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Andy Lutomirski <luto@amacapital.net>, aarcange@redhat.com,
        ak@linux.intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        criu@openvz.org, mingo@redhat.com, john.stultz@linaro.org,
        tglx@linutronix.de
Date: Sat, 15 Dec 2012 00:09:28 +0100
In-Reply-To: <50CBAC61.5010600@zytor.com>
References: <1355343572-23074-1-git-send-email-stefani@seibold.net>
	 <50C9148C.4040308@zytor.com> <1355378005.24283.11.camel@wall-e>
	 <1d3061cb-76d0-4e42-9b75-a975b05384ec@email.android.com>
	 <1355379433.24701.1.camel@wall-e>
	 <f984cb31-baa5-4176-8e85-37266e2cfb8d@email.android.com>
	 <1355383038.18653.2.camel@wall-e>
	 <CALCETrWmYpEh9pLiohF+yu9FnrVfSNdHB_TQOKL6+LkdTF+cVw@mail.gmail.com>
	 <50CA6E4C.6000305@zytor.com>
	 <CALCETrV1kvhOvDpzTavGb1X9HT+PdEPXJ0H8afs7jzxpcF7Kjg@mail.gmail.com>
	 <50CA81A4.9040702@zytor.com>
	 <CALCETrWCMQys5MCbd6E_7c+Bsvph5cfkrDDm5tNpyBdgVE-YeQ@mail.gmail.com>
	 <50CA85BD.7070502@zytor.com>
	 <CALCETrWKDJd1T_VCRNAzD-KTtYBbmvgE_ZYvb8uN4nBUYQvkgA@mail.gmail.com>
	 <8c3585bc-fc7d-4826-913c-f4581494d91d@email.android.com>
	 <CALCETrX5KUiQaV7dsAFa1SYyWPjUVwh43HvbPwqPStMxqE0ctQ@mail.gmail.com>
	 <50CAE485.5020608@parallels.com> <50CBAC61.5010600@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 14.12.2012, 14:46 -0800 schrieb H. Peter Anvin:
> On 12/14/2012 12:34 AM, Pavel Emelyanov wrote:
> > On 12/14/2012 06:20 AM, Andy Lutomirski wrote:
> >> On Thu, Dec 13, 2012 at 6:18 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> >>> Wouldn't the vdso get mapped already and could be mremap()'d.  If we
> >> really need more control I'd almost push for a device/filesystem node
> >> that could be mmapped the usual way.
> >>
> >> Hmm.  That may work, but it'll still break ABI.  I'm not sure that
> >> criu is stable enough yet that we should care.  Criu people?
> > 
> > It's not yet, but we'd still appreciate the criu-friendly vdso redesign.
> > 
> >> (In brief summary: how annoying would it be if the vdso was no longer
> >> just a bunch of constant bytes that lived somewhere?)
> > 
> > It depends on what vdso is going to be. In the perfect case it should
> > a) be mremap-able to any address (or be at fixed address _forever_, but
> >    I assume this is not feasible);
> > b) have entry points at fixed (or somehow movable) places.
> > 
> > I admit that I didn't understand your question properly, if I did,
> > please correct me.
> > 
> 
> Either way... criu on the side, we should proceed with this vdso
> redesign and get support for the 32-bit entry points including compat
> mode on x86-64.
> 
> 	-hpa
> 
> 

Sorry for not following the discussion, but im am currently trying to
compile the vclocktime.c as a 32 bit object. Most of the (clever) work
is done.

After this the next step is to map the needed fixmaps into the 32 bit
address space. Maybe this can be done with install_special_mapping().

I think i will do this job in the next days.

- Stefani


