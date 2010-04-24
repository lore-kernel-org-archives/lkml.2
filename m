Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab0DXC1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 22:27:25 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:64979 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab0DXC1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 22:27:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nL7Mme1DHEDk0XoW47NGsIY0wjW70YodRekH+WI3geJtOxE4dys83GL+14u9LWpnDy
         eH2Efjnl6YJfjiWB4zQ9n3CBvOcPEThEGfDWM9qaT4YDbHt9N8/4VswdDBdFGvtuWk47
         4bM/ivKHJgE0ReaSZOuW7VYdnYv/hpMprvhn0=
Date: Sat, 24 Apr 2010 04:27:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, William Cohen <wcohen@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Li Zefan <lizf@cn.fujitsu.com>,
       Stephane Eranian <eranian@google.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [GIT PULL] perf tools updates
Message-ID: <20100424022729.GB31069@nowhere>
References: <1272074742-3654-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272074742-3654-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 24, 2010 at 04:05:33AM +0200, Frederic Weisbecker wrote:
> Ingo,
> 
> Please pull the perf/core branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/core
> 
> Thanks,
> 	Frederic



I forgot to highlight some things here.

- The -M option is not used anymore. Well actually I just checked and it's
  used by the record perl/python scripts. But it's not needed there anymore, so
  I'll drop it in another pass. But globally it's over with the buffers
  multiplexing needs.

- But I haven't plugged the reordering thing to the live mode, because I'm
  not sure exactly if that would be welcome. With live mode we want the
  events as they arrive, using the reordering there would make it get the
  events per bunches of 2 seconds slices. I guess we'll figure out a solution
  for that.

- Perf lock gets into a better shape. There is still some work to make
  it truly usable though. I need to unearth the event injection thing
  to lower the size of the events, profile by lock classes, etc...

- Various important fixes

Thanks.

