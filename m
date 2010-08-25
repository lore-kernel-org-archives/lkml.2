Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab0HYAen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:34:43 -0400
Received: from smtp-out.google.com ([74.125.121.35]:21987 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab0HYAem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:34:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cU68b4g+c3VEh/Bzf9EJCcTyGRQppuu+3ymyVlQEmoaGVYp2aeN4cjnTDDGKiexVLA
         syYWX7bZfqMx1lOYRhIQ==
MIME-Version: 1.0
In-Reply-To: <20100825092010.cfe91b1a.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100820185816.1dbcd53a.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTi=imK6Px+JrdVupg2V3jtN9pgmEdWv=+aB1XKLY@mail.gmail.com>
	<20100825092010.cfe91b1a.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 24 Aug 2010 17:34:38 -0700
Message-ID: <AANLkTikD3CFRPo7WvWwCnLQ+jzEs6rUk1sivYM3aRbGJ@mail.gmail.com>
Subject: Re: [PATCH 1/5] cgroup: ID notification call back
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com,
        "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 5:20 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> Hmm, sure. I'll change the ->create() interface.  O.K. ?
>

Hmm. An alternative (possibly cleaner) would be:

1) add a css_size field in cgroup_subsys that contains the size of the
per-subsystem structure
2) change cgroups to allocate and populate the css *before* calling
create(), since it now knows the actual size
3) simplify all the subsystem create() methods since they no longer
have to worry about allocation or out-of-memory handling
4) also add a top_css field in cgroups that allows cpusets to use the
statically-allocated top_cpuset since it's initialized prior to memory
allocation being reliable

This avoids us having to pass in any new parameters to the create()
method in future since they can be populated in the CSS.

Paul
