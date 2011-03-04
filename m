Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242Ab1CDXWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 18:22:18 -0500
Received: from shutemov.name ([188.40.19.243]:46520 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587Ab1CDXWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 18:22:17 -0500
Date: Sat, 5 Mar 2011 01:22:16 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
Subject: Re: [PATCH, v7] cgroups: introduce timer slack controller
Message-ID: <20110304232216.GA18343@shutemov.name>
References: <1299084001-3916-1-git-send-email-kirill@shutemov.name>
 <1299084001-3916-2-git-send-email-kirill@shutemov.name>
 <1299265422.22521.2.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299265422.22521.2.camel@laptop>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 08:03:42PM +0100, Peter Zijlstra wrote:
> On Wed, 2011-03-02 at 18:40 +0200, Kirill A. Shutsemov wrote:
> > -       if (ret < current->timer_slack_ns)
> > -               return current->timer_slack_ns;
> > -       return ret;
> > +       return clamp(__estimate_accuracy(&now),
> > +                       get_task_timer_slack(current), LONG_MAX);
> 
> That actually makes the code worse, how about:
> 
>   min(__estimate_accuracy(), get_task_timer_slack()) ?

It's better. Thanks.

-- 
 Kirill A. Shutemov
