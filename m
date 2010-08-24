Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab0HXRWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 13:22:03 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48164 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab0HXRWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 13:22:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kkkOxC3dCH0K1GehI0LfmwyM49zyxbzq+aFfryqx0zK4oEWmgcKEotYQoiAbvT0Fh4
         32KunXCYL7Yx1vDMBbAroOPtrjDWQ73HH8k70sV2/DaJv2BOqfRJorErBkqagOWT3hcI
         ycELKP+QZ8pWbh64qahao/jGu0XJRHcdCuMlg=
Date: Tue, 24 Aug 2010 21:21:57 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
	perfctrs
Message-ID: <20100824172157.GE5723@lenovo>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com> <20100820152510.GA4167@elte.hu> <20100823085339.GA26713@elte.hu> <20100824162252.GB5723@lenovo> <20100824170936.GH26154@erda.amd.com> <20100824172022.GD5723@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100824172022.GD5723@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 09:20:22PM +0400, Cyrill Gorcunov wrote:
> On Tue, Aug 24, 2010 at 07:09:36PM +0200, Robert Richter wrote:
> > On 24.08.10 12:22:52, Cyrill Gorcunov wrote:
> > > Btw, guys, I fail to see how new nmi_watchdog work, we have
> > > default_do_nmi
> > >   if (!(reason & 0xc0)) {
> > >     if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT) == == NOTIFY_STOP)
> > >       return
> > >     if (nmi_watchdog_tick(regs, reason))
> > >       return
> > > 
> > > but perf_event_nmi_handler returns NOTIFY_STOP when watchdog is perf event
> > > and nmi_watchdog_tick _never_ called, or (most probably) I miss something?
> > 
> > The watchdog is disabled during profiling (perf and oprofile) by
> > calling disable_lapic_nmi_watchdog().
> > 
> > -Robert
> >
> 
> Huh? iirc Don have switched nmi watchdog to native perf subsystem, ie watchdog
> uses PERF_COUNT_HW_CPU_CYCLES event, letme check...
>  
> 	-- Cyrill

False alarm, perf watchdog uses own handler. Sorry for noise ;)

	-- Cyrill
