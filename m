Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab1I0VBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 17:01:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59963 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab1I0VBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 17:01:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v1 1/2] PM/runtime: introduce trace points for tracing rpm_* functions
Date: Tue, 27 Sep 2011 23:03:34 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: tom.leiming@gmail.com, stern@rowland.harvard.edu,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, fweisbec@gmail.com,
        Ming Lei <ming.lei@canonical.com>
References: <1317118338-4040-1-git-send-email-tom.leiming@gmail.com> <201109272236.03683.rjw@sisk.pl> <1317156234.26514.39.camel@gandalf.stny.rr.com>
In-Reply-To: <1317156234.26514.39.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109272303.34603.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 27, 2011, Steven Rostedt wrote:
> On Tue, 2011-09-27 at 22:36 +0200, Rafael J. Wysocki wrote:
> 
> > > 	TP_printk("%pS:%s ret=%d", (void *)__entry->ip, __get_str(name),
> > > 		__entry->ret)
> > > 
> > > try that.
> > 
> > Well, that certainly will work, but is it the right fix?
> 
> Hehe, yes!  The pS means to take a pointer and return the string version
> of the address. Like "schedule+0x3a". __entry->ip is the address of the
> function that called it __THIS_IP__ but we want to convert that into a
> string name.
> 
> We use ip because both perf and trace-cmd should be smart enough to
> parse it too. As they both store the kallsyms into the data file.
> 
> The (void *) is used because pS wants a pointer, and we stored the
> address as an unsigned long.

OK, good.

I've applied both patches (with the above fix folded into the first one)
to linux-pm/pm-runtime (and merged into my linux-next branch), so they will be
pushed for 3.2.

Thanks,
Rafael
