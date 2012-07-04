Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab2GDQgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:36:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab2GDQgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 12:36:15 -0400
Date: Wed, 4 Jul 2012 13:35:43 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] perf, x86: Making hardware events translations
 available in sysfs
Message-ID: <20120704163543.GB7533@infradead.org>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
 <1341352848-11833-5-git-send-email-jolsa@redhat.com>
 <1341397330.2507.85.camel@laptop>
 <1341398311.2507.98.camel@laptop>
 <20120704120155.GE960@krava.redhat.com>
 <1341404088.2507.108.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341404088.2507.108.camel@laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 04, 2012 at 02:14:48PM +0200, Peter Zijlstra escreveu:
> On Wed, 2012-07-04 at 14:01 +0200, Jiri Olsa wrote:
> > >   ret = sprintf(page, "event=0x%02llx", event);
> > >   if (umask)
> > >     ret += sprintf(page + ret, ",umask=0x%02llx", umask);
> > >   if (inv)
> > >     ret += sprintf(page + ret, ",inv");
> > >   if (cmask)
> > >     ret += sprintf(page + ret, ",cmask=0x%02llx", cmask);
> > >   sprintf(page + ret, "\n");
> 
> There's a ret += missing there.

And also don't use sprintf or snprintf, use scnprintf, the former have
confusing semantics for the return value, see the man pages.

- Arnaldo
