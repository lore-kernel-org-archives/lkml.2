Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab1JSIAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 04:00:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52682 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab1JSIAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 04:00:42 -0400
MIME-Version: 1.0
In-Reply-To: <1319010872.29774.4.camel@twins>
References: <1316758874.7393.2.camel@marge.simson.net> <4E7C2E7F.40307@cn.fujitsu.com>
 <1316762345.8168.4.camel@marge.simson.net> <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
 <1316770936.6641.11.camel@marge.simson.net> <1316775204.7562.9.camel@marge.simson.net>
 <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
 <1316788392.6544.33.camel@marge.simson.net> <1318224892.6161.45.camel@marge.simson.net>
 <1318233815.6527.5.camel@marge.simson.net> <1318925436.9641.23.camel@marge.simson.net>
 <CALdu-PDurd4-_jpkhHJ9VuripesWGfUA+Mi8PoyRjJsmxdRqLw@mail.gmail.com>
 <1319001860.6222.34.camel@marge.simson.net> <1319010872.29774.4.camel@twins>
From: Paul Menage <paul@paulmenage.org>
Date: Wed, 19 Oct 2011 01:00:22 -0700
X-Google-Sender-Auth: F4lJLSdaex-rjAXqbmjlt0uUE1k
Message-ID: <CALdu-PCJnBajrBp04R1_y1qze8awiYEhj-Bjnaci3G+vRFtMYA@mail.gmail.com>
Subject: Re: [patch-final] Re: patch] cpusets, cgroups: disallow attaching kthreadd
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <htejun@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 12:54 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> I really think that if we want to restrain userspace from doing
> something stupid we might as well do something that makes sense,

Totally agreed. There are two solutions proposed, both of which make
sense as a method of solving the problem, and which have different
levels of effect on the existing user-visible API. So which do we
prefer?

If you just want to make sure people think about it before there's a
problem rather than after, then an alternative would be to have a flag
in cgroup_subsys such as allow_kthreadd, which defaults to false and
can be explicitly set to true for subsystems that are kthreadd-safe.

Paul
