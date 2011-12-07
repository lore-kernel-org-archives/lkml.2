Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab1LGSnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:43:09 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49680 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968Ab1LGSnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:43:07 -0500
Date: Wed, 7 Dec 2011 22:43:01 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Introduce the /proc/<pid>/children entry v2
Message-ID: <20111207184301.GO21678@moon>
References: <20111206181026.GO29781@moon>
 <20111206143313.ac2e7287.akpm@linux-foundation.org>
 <20111206223558.GQ29781@moon>
 <20111207094144.GB21678@moon>
 <20111207182720.GB7610@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207182720.GB7610@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 10:27:26AM -0800, Tejun Heo wrote:
> Hello,
> 
> On Wed, Dec 07, 2011 at 01:41:44PM +0400, Cyrill Gorcunov wrote:
> > +static void children_seq_stop(struct seq_file *seq, void *v)
> > +{
> > +	rcu_read_unlock();
> > +	seq_printf(seq, "\n");
> > +}
> 
> Wouldn't this add newline on page boundary?  Newline should be printed
> at the end of the whole sequence but seq_stop() is called at buffer
> boundaries.
> 

Yeah, good point. I'll update! Thanks Tejun (somehow missed this
call in traverse()).

	Cyrill
