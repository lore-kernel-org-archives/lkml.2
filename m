Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933851Ab0HFGDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 02:03:52 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:51945 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab0HFGDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 02:03:50 -0400
Date: Fri, 6 Aug 2010 02:02:24 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Paul Menage <menage@google.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com,
        oleg@redhat.com
Subject: Re: [PATCH v4 1/2] cgroups: read-write lock CLONE_THREAD forking
 per threadgroup
Message-ID: <20100806060224.GA1351@ghc17.ghc.andrew.cmu.edu>
References: <20100730235649.GA22644@ghc17.ghc.andrew.cmu.edu>
 <20100730235754.GB22644@ghc17.ghc.andrew.cmu.edu>
 <AANLkTikpNG2Y3S3AyxAbCkMynKu1u5yKPrw=bh+uy=9R@mail.gmail.com>
 <20100804043328.GB11950@ghc17.ghc.andrew.cmu.edu>
 <AANLkTi=dhym3c+XJVjoObROcw=mz2Y+a2R5oMdePK3Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=dhym3c+XJVjoObROcw=mz2Y+a2R5oMdePK3Ng@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.8.6.53315
X-SMTP-Spam-Clean: 8% (
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_1099 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS , __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 09:34:22PM -0700, Paul Menage wrote:
> On Tue, Aug 3, 2010 at 9:33 PM, Ben Blum <bblum@andrew.cmu.edu> wrote:
> >> As far as the #ifdef mess goes, it's true that some people don't have
> >> CONFIG_CGROUPS defined. I'd imagine that these are likely to be
> >> embedded systems with a fairly small number of processes and threads
> >> per process. Are there really any such platforms where the cost of a
> >> single extra rwsem per process is going to make a difference either in
> >> terms of memory or lock contention? I think you should consider making
> >> these additions unconditional.
> >
> > That's certainly an option, but I think it would be clean enough to put
> > static inline functions just under the signal_struct definition.
> 
> Either sounds fine to me. I suspect others have a stronger opinion.
> 
> Paul
> 

Any other votes? One set of static inline functions (I'd call them
threadgroup_fork_{read,write}_{un,}lock) or just remove the ifdefs
entirely? I'm inclined to go with the former.

-- Ben
