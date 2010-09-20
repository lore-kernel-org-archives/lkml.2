Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab0ITSVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:21:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49929 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051Ab0ITSVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:21:48 -0400
X-Authority-Analysis: v=1.1 cv=Ba7GFA6IM/Rlu/bGJ5lftWmk/oljGo5ZwASPcBcXAAo= c=1 sm=0 a=QOP7y4XR2NEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=-T2CzcbACM4l99N0KBEA:9 a=vVinNvPp3DdiRk1gs58A:7 a=lCFTJuztA5FgWasqyXINElwRDG8A:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH trace-cmd] plugin_kvm: disassemble instructions for
 kvm_emulate_insn
From: Steven Rostedt <rostedt@goodmis.org>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-users@vger.kernel.org
In-Reply-To: <4C972EA6.2070704@redhat.com>
References: <1284906837-2431-1-git-send-email-avi@redhat.com>
	 <4C972EA6.2070704@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 20 Sep 2010 14:21:45 -0400
Message-ID: <1285006905.23122.364.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-20 at 11:51 +0200, Avi Kivity wrote:
> On 09/19/2010 04:33 PM, Avi Kivity wrote:
> > Override kvm_emulate_insn formatting to use a disassembler to format
> > the emulated instruction.  If a disassembler (udis86) is not available,
> > fall back to showing the instruction bytes in hex.
> >
> > Signed-off-by: Avi Kivity<avi@redhat.com>
> > ---
> >
> > Note 1: on top of 'master' with 'trace-cmd-kvm' cherry-picked on top.
> >
> > Note 2: I get output of the form
> >
> > ... kvm_emulate_insn:     0:fffff800010527b5: mov $0x0, 0xfffe00b0CAN'T FIND FIELD "guest_rip"
> >
> > which leads me to believe there is a bug in trace_seq_printf when the input
> > to %s is "".
> >
> >
> 
> Note 3: this is not thread safe.  If trace-cmd wants to be (or is) 
> multithreaded, we need some kind of plugin context that is passed to all 
> plugin methods, which is initialized separately for each thread.
> 
> Or we can be lazy and use thread local storage.
> 

No need, I purposely, made trace-cmd non-threaded. Too much hassles ;-)

-- Steve


