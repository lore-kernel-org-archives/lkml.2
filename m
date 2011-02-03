Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab1BCFsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 00:48:32 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55567 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab1BCFsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 00:48:31 -0500
Date: Wed, 2 Feb 2011 21:48:26 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: "Kirill A. Shutsemov" <kirill@shutemov.name>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH, v3 2/2] cgroups: introduce timer slack subsystem
Message-ID: <20110203054826.GU16432@count0.beaverton.ibm.com>
References: <1296679656-31163-1-git-send-email-kirill@shutemov.name>
 <1296679656-31163-3-git-send-email-kirill@shutemov.name>
 <AANLkTikAbmFmQNGgYMYhTOS8L5nU39edcTjQXNpdxGy2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikAbmFmQNGgYMYhTOS8L5nU39edcTjQXNpdxGy2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 03:23:15PM -0800, Paul Menage wrote:
> On Wed, Feb 2, 2011 at 12:47 PM, Kirill A. Shutsemov
<kirill@shutemov.name> wrote:
> > +static int tslack_write_range(struct cgroup *cgroup, struct cftype *cft,
> > +               u64 val)
> > +{
> > +       struct timer_slack_cgroup *tslack_cgroup;
> > +       struct cgroup_iter it;
> > +       struct task_struct *task;
> > +
> > +       if (!val)
> > +               return -EINVAL;
> > +
> > +       tslack_cgroup = cgroup_to_tslack_cgroup(cgroup);
> > +       switch (cft->private) {
> > +       case TIMER_SLACK_MIN:
> > +               if (val > tslack_cgroup->max_slack_ns)
> > +                       return -EINVAL;
> > +               tslack_cgroup->min_slack_ns = val;
> > +               break;
> > +       case TIMER_SLACK_MAX:
> > +               if (val < tslack_cgroup->min_slack_ns)
> > +                       return -EINVAL;
> > +               tslack_cgroup->max_slack_ns = val;
> > +               break;
> > +       default:
> > +               BUG();
> > +       }
> > +
> 
> Don't we want to keep the min/max applied hierarchically as well? i.e.
> a child can't set its min/max outside the range of its parents?

That was my expectation as well.

Cheers,
	-Matt Helsley
