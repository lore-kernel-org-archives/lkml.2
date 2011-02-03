Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab1BCT74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 14:59:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:41151 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756342Ab1BCT7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 14:59:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,421,1291622400"; 
   d="scan'208";a="599229847"
Date: Thu, 3 Feb 2011 11:57:43 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Paul Menage <menage@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH, v3 2/2] cgroups: introduce timer slack subsystem
Message-ID: <20110203115743.1ef9a4c2@putvin>
In-Reply-To: <AANLkTikvkUT8+U=bX6X2n7kMbnAt6evxTy1BqiX+TWpH@mail.gmail.com>
References: <1296679656-31163-1-git-send-email-kirill@shutemov.name>
	<1296679656-31163-3-git-send-email-kirill@shutemov.name>
	<20110202145605.6c9006fa@putvin>
	<20110203092229.GB1083@shutemov.name>
	<20110203095117.76a568fc@putvin>
	<AANLkTikvkUT8+U=bX6X2n7kMbnAt6evxTy1BqiX+TWpH@mail.gmail.com>
Organization: OTC
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011 10:12:51 -0800
Paul Menage <menage@google.com> wrote:

> On Thu, Feb 3, 2011 at 9:51 AM, Jacob Pan
> <jacob.jun.pan@linux.intel.com> wrote:
> >
> > I think this logic defeats the purpose of having timer_slack
> > subsystem in the first place. IMHO, the original intention was to
> > have grouping effect of tasks in the cgroup.
> 
> You can get the semantics you want by just setting min_slack_ns =
> max_slack_ns.
> 
true. it will just make set fail when min = max. it is awkward and
counter intuitive when you want to change the group timer_slack. you
will have to move both min and max to clamp the value, where set
function can not be used.

In addition, when a parent changes min = max, I don't see the current
code enforce new settings on the children. Am i missing something?

In my use case, i want to put some apps into a managed group where
relaxed slack value is used, but when time comes to move the app out of
that cgroup, we would like to resore the original timer slack. I see
having a current value per cgroup can be useful if we let timer code
pick whether to use task slack value or the cgroup slack value.
Or we have to cache the old value per task
