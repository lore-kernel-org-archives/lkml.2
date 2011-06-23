Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288Ab1FWLxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 07:53:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52959 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab1FWLxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 07:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=f9iaiM8CPNOx47zeGO/3aV696ISZV72ZCdavFbfrj/nzX9rh9CzCWdIOo4vgCDRDh9
         lhd83/1pmM+jaUSnVdil+8qbTjuPnXTX3gKImtrvt5GYaf7vQ/mR1RnAg61NOJil/5JI
         f1/h9NIDT/2EhgP98VeEieKaKW9Ea9SKNDWWU=
Date: Thu, 23 Jun 2011 15:53:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event v2
Message-ID: <20110623115327.GG10238@sun>
References: <BANLkTim8OdhTdaayHZAKSXWhmN0anEhieQ@mail.gmail.com>
 <20110621183227.GG21641@sun>
 <20110622082756.GK21641@sun>
 <20110622092134.GO21641@sun>
 <20110623064835.GB10238@sun>
 <BANLkTikVaOz5DYjKSU-jxVBw_Lw9ihV7BQ@mail.gmail.com>
 <20110623095439.GC10238@sun>
 <20110623110706.GE10238@sun>
 <20110623114055.GV3765@redhat.com>
 <BANLkTikR7j0iZ7SLsfkz=2bpTm2uaO_=5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikR7j0iZ7SLsfkz=2bpTm2uaO_=5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 01:44:36PM +0200, Stephane Eranian wrote:
> On Thu, Jun 23, 2011 at 1:40 PM, Don Zickus <dzickus@redhat.com> wrote:
> > On Thu, Jun 23, 2011 at 03:07:06PM +0400, Cyrill Gorcunov wrote:
> >> On Thu, Jun 23, 2011 at 01:54:39PM +0400, Cyrill Gorcunov wrote:
> >> ...
> >> > >
> >> > > No new hidden event, just a x86_pmu + a per-arch callbacks.
> >> >
> >> > Looks quite good for me, Don? (i'll cook some draft patch for review meanwhile).
> >> >
> >> >     Cyrill
> >>
> >> Since we are going to make __weak linking anyway maybe something like below
> >> fit even beter? (untested)
> >
> > I don't think the compiler knows what platform you are running on and may
> > just blindly link your new p4 function for all x86s, which is probably not
> > what you want.
> >
> Don, is right. You need the level of indirection I had in my outline patch.
> 
> You also don't need the:
> +       if (wd_attr->type       != PERF_TYPE_HARDWARE ||
> +          wd_attr->attr.config != PERF_COUNT_HW_CPU_CYCLES)
> +               return;
> 
> In the p4 callback given you know your coming in for the watchdog.
> 

Yes, that is why in __weak implementation I dropped it. So guys,
what we stick with -- __weak with second level indirection?

	Cyrill
