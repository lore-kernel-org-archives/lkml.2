Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751000Ab1IVPSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 11:18:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55362 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab1IVPSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 11:18:04 -0400
Subject: Re: [PATCH 1/9] Remove parent field in cpuacct cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Balbir Singh <bsingharora@gmail.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        xemul@parallels.com, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, mingo@elte.hu, jbottomley@parallels.com
Date: Thu, 22 Sep 2011 17:17:17 +0200
In-Reply-To: <CAKTCnzk=i1a3DHrforcaOCBdhjv1xi=5W=eiJiZoK4BNb3wqVw@mail.gmail.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
	 <1316030695-19826-2-git-send-email-glommer@parallels.com>
	 <1316448186.1511.19.camel@twins> <4E776937.1070108@parallels.com>
	 <1316449160.6091.5.camel@twins> <4E776E36.6040906@parallels.com>
	 <1316450385.6091.9.camel@twins> <4E7770BD.6050902@parallels.com>
	 <1316457653.6091.16.camel@twins> <20110920172930.GA5318@linux.vnet.ibm.com>
	 <CAKTCnzk=i1a3DHrforcaOCBdhjv1xi=5W=eiJiZoK4BNb3wqVw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316704637.31429.25.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 20:41 +0530, Balbir Singh wrote:
> On Tue, Sep 20, 2011 at 10:59 PM, Srivatsa Vaddagiri
> <vatsa@linux.vnet.ibm.com> wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-19 20:40:53]:
> >
> >> > Note I was talking about cpuusage. Well, in this case, I myself fail
> >> > to see the value of the whole cpuusage thing...
> >
> > If I recall, cpuacct was prototyped by Paul Menage (and later modified
> > by Balbir) as a way to demonstrate cgroup controller ..It was one
> > of those "first" cgroups controllers written to demonstrate how cgroups worked.
> >
> > With regard to its value, it does provide a handy interface to measure
> > cpu utilization of cgroups (vs having to manually sum up task's
> > utilization) and afaik libvirt makes use of it (although I
> > don't think anyone reads it at "high" frequency).
> >
> 
> Android makes heavy use of cpuacct as well. We invented it to do cpu
> accounting independent of control

But its a massive waste of time to have to iterate a double hierarchy,
cache-miss heaven.

Or so people really have independent cgroups as well? I thought people
just co-mount all this crap.
