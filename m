Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab2GRP0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 11:26:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687Ab2GRP0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 11:26:09 -0400
Message-ID: <1342625061.3295.5.camel@bandura>
Subject: Re: [PATCH] uprobe: fix misleading log entry
From: Anton Arapov <anton@redhat.com>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Date: Wed, 18 Jul 2012 17:24:21 +0200
In-Reply-To: <CACV3sbKNmeKqvroYp4C=gna7ht4dvYmrCNA7q9Sa0GfVjx7F_A@mail.gmail.com>
References: <CACV3sbL2gRjoFi8yyUW6Bu2ZZ4PW+ytZsfx_65KA8s_5DEB+ZQ@mail.gmail.com>
	 <20120718092252.GD5006@linux.vnet.ibm.com>
	 <CACV3sbKNmeKqvroYp4C=gna7ht4dvYmrCNA7q9Sa0GfVjx7F_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 19:43 +0800, Jovi Zhang wrote:
> On Wed, Jul 18, 2012 at 5:22 PM, Srikar Dronamraju
> <srikar@linux.vnet.ibm.com> wrote:
> > * Jovi Zhang <bookjovi@gmail.com> [2012-07-18 11:08:42]:
> >
> >> From 68232ef2decae95b807f2f3763e8ea99c1a3b2ae Mon Sep 17 00:00:00 2001
> >> From: Jovi Zhang <bookjovi@gmail.com>
> >> Date: Wed, 18 Jul 2012 17:51:26 +0800
> >> Subject: [PATCH] uprobe: fix misleading log entry
> >>
> >> There don't have any 'r' prefix in uprobe event naming, remove it.
> >>
> >> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
> >> ---
> >>  kernel/trace/trace_uprobe.c |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> >> index cf382de..852a584 100644
> >> --- a/kernel/trace/trace_uprobe.c
> >> +++ b/kernel/trace/trace_uprobe.c
> >> @@ -191,7 +191,7 @@ static int create_trace_uprobe(int argc, char **argv)
> >>       if (argv[0][0] == '-')
> >>               is_delete = true;
> >>       else if (argv[0][0] != 'p') {
> >> -             pr_info("Probe definition must be started with 'p', 'r' or" " '-'.\n");
> >> +             pr_info("Probe definition must be started with 'p' or '-'.\n");
> >>               return -EINVAL;
> >>       }
> >>
> >
> > Yes, uprobes doesnt support return probes. So we should not have
> > mentioned about r.
> Hmm, Does this have specific reason? or just not implemented?

It is not implemented. I'm slowly(very) moving towards it. You are
welcome to take a look.
  https://github.com/arapov/linux-aa/commits/uretprobes

Anton.


