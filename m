Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab1BDNel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 08:34:41 -0500
Received: from shutemov.name ([188.40.19.243]:48379 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab1BDNek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:34:40 -0500
Date: Fri, 4 Feb 2011 15:34:39 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH, v3 2/2] cgroups: introduce timer slack subsystem
Message-ID: <20110204133439.GA7181@shutemov.name>
References: <1296679656-31163-1-git-send-email-kirill@shutemov.name>
 <1296679656-31163-3-git-send-email-kirill@shutemov.name>
 <20110202145605.6c9006fa@putvin>
 <20110203092229.GB1083@shutemov.name>
 <20110203095117.76a568fc@putvin>
 <AANLkTikvkUT8+U=bX6X2n7kMbnAt6evxTy1BqiX+TWpH@mail.gmail.com>
 <20110203115743.1ef9a4c2@putvin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203115743.1ef9a4c2@putvin>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 11:57:43AM -0800, Jacob Pan wrote:
> On Thu, 3 Feb 2011 10:12:51 -0800
> Paul Menage <menage@google.com> wrote:
> 
> > On Thu, Feb 3, 2011 at 9:51 AM, Jacob Pan
> > <jacob.jun.pan@linux.intel.com> wrote:
> > >
> > > I think this logic defeats the purpose of having timer_slack
> > > subsystem in the first place. IMHO, the original intention was to
> > > have grouping effect of tasks in the cgroup.
> > 
> > You can get the semantics you want by just setting min_slack_ns =
> > max_slack_ns.
> > 
> true. it will just make set fail when min = max. it is awkward and
> counter intuitive when you want to change the group timer_slack. you
> will have to move both min and max to clamp the value, where set
> function can not be used.

Interface is very similar to /sys/devices/system/cpu/cpuX/cpufreq.
I think it's sane. If you want some extention, you can do it with
userspace helper.

> In addition, when a parent changes min = max, I don't see the current
> code enforce new settings on the children. Am i missing something?

I've missed it. I'll fix.

> In my use case, i want to put some apps into a managed group where
> relaxed slack value is used, but when time comes to move the app out of
> that cgroup, we would like to resore the original timer slack. I see
> having a current value per cgroup can be useful if we let timer code
> pick whether to use task slack value or the cgroup slack value.
> Or we have to cache the old value per task

What's mean "original timer slack" if you are free to move a task
between a lot of cgroups and process itself free to change it anytime?

-- 
 Kirill A. Shutemov
