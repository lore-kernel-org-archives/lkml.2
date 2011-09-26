Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab1IZKfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 06:35:32 -0400
Received: from ozlabs.org ([203.10.76.45]:56070 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab1IZKfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 06:35:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] oom: do not live lock on frozen tasks
In-Reply-To: <20110926082837.GC10156@tiehlicka.suse.cz>
References: <alpine.DEB.2.00.1108241226550.31357@chino.kir.corp.google.com> <20110825091920.GA22564@tiehlicka.suse.cz> <20110825151818.GA4003@redhat.com> <20110825164758.GB22564@tiehlicka.suse.cz> <alpine.DEB.2.00.1108251404130.18747@chino.kir.corp.google.com> <20110826070946.GA7280@tiehlicka.suse.cz> <20110826085610.GA9083@tiehlicka.suse.cz> <alpine.DEB.2.00.1108260218050.14732@chino.kir.corp.google.com> <20110826095356.GB9083@tiehlicka.suse.cz> <alpine.DEB.2.00.1108261110020.13943@chino.kir.corp.google.com> <20110926082837.GC10156@tiehlicka.suse.cz>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 26 Sep 2011 19:58:50 +0930
Message-ID: <87sjnjk36l.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Sep 2011 10:28:37 +0200, Michal Hocko <mhocko@suse.cz> wrote:
> On Fri 26-08-11 11:13:40, David Rientjes wrote:
> > I'd love to be able to do a thaw on a PF_FROZEN task in the oom killer 
> > followed by a SIGKILL if that task is selected for oom kill without an 
> > heuristic change.  Not sure if that's possible, so we'll wait for Rafael 
> > to chime in.
> 
> We have discussed that with Rafael and it should be safe to do that. See
> the patch bellow.
> The only place I am not entirely sure about is run_guest
> (drivers/lguest/core.c). It seems that the code is able to cope with
> signals but it also calls lguest_arch_run_guest after try_to_freeze.

Yes; if you want to kill things in the refrigerator(), then will a

		if (cpu->lg->dead || task_is_dead(current))
                        break;

Work?  That break means we return to the read() syscall pretty much
immediately.

Thanks for the CC,
Rusty.
