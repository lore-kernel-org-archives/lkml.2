Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289Ab1FWLvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 07:51:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42213 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab1FWLvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 07:51:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=djD1SP8C3rOnZySyiY08pRFW0bWc8fACwGSTJBd+8gEQ4RbVcrDFNBCZJRj4kzWIPK
         NE7TAqEx2+fxxa60z4pvlxURhma7Iz7Z2VWdSUoXww3Jil0/YOMyPwnxEzxY2+SjbEQD
         dWXy9f97/tpnek9ArhUdcrgtzDgtayf386rg4=
Date: Thu, 23 Jun 2011 15:51:29 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event v2
Message-ID: <20110623115128.GF10238@sun>
References: <20110621175421.GF21641@sun>
 <BANLkTim8OdhTdaayHZAKSXWhmN0anEhieQ@mail.gmail.com>
 <20110621183227.GG21641@sun>
 <20110622082756.GK21641@sun>
 <20110622092134.GO21641@sun>
 <20110623064835.GB10238@sun>
 <BANLkTikVaOz5DYjKSU-jxVBw_Lw9ihV7BQ@mail.gmail.com>
 <20110623095439.GC10238@sun>
 <20110623110706.GE10238@sun>
 <20110623114055.GV3765@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623114055.GV3765@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 07:40:55AM -0400, Don Zickus wrote:
> On Thu, Jun 23, 2011 at 03:07:06PM +0400, Cyrill Gorcunov wrote:
> > On Thu, Jun 23, 2011 at 01:54:39PM +0400, Cyrill Gorcunov wrote:
> > ...
> > > > 
> > > > No new hidden event, just a x86_pmu + a per-arch callbacks.
> > > 
> > > Looks quite good for me, Don? (i'll cook some draft patch for review meanwhile).
> > > 
> > > 	Cyrill
> > 
> > Since we are going to make __weak linking anyway maybe something like below
> > fit even beter? (untested)
> 
> I don't think the compiler knows what platform you are running on and may
> just blindly link your new p4 function for all x86s, which is probably not
> what you want.

As only there will be second/third and so on implementation of hw_nmi_watchdog_set_attr
then indeed it become a problem, for a while it's not, only single
implementation. I personally don't like much __weak linking until there is
no other choise, so explicit general event for x86 in a sake of nmi-watchdog
(without any __weak functions) is my favorite but I'm fine with Stephane proposal
as well, so Don what is your choise?

	Cyrill
