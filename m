Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab0KJOjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:39:22 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58896 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109Ab0KJOjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:39:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HliAOgCAXg/UuBr4z5vO9A1CWs/cOlw0sgFDsVn9xDhAjtUh2J1aRnSrXdCf2lj7Mm
         zwMT4wDnKaouRNfsEQQ9etwKM5cGNBZo0KodJxAmkwTBdlbJ1n84Nkn/yGDfhodTIVjH
         W0d0LpHJpeuh32LrxfS+XUdB/nCuvpGhT7bzc=
Subject: Re: [PATCH v2]oom-kill: CAP_SYS_RESOURCE should get bonus
From: "Figo.zhang" <figo1802@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Figo.zhang" <zhangtianfei@leadcoretech.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>
In-Reply-To: <alpine.DEB.2.00.1011091300510.7730@chino.kir.corp.google.com>
References: <1288834737.2124.11.camel@myhost>
	 <alpine.DEB.2.00.1011031847450.21550@chino.kir.corp.google.com>
	 <20101109195726.BC9E.A69D9226@jp.fujitsu.com>
	 <20101109122437.2e0d71fd@lxorguk.ukuu.org.uk>
	 <alpine.DEB.2.00.1011091300510.7730@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 22:38:11 +0800
Message-ID: <1289399891.10699.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 13:06 -0800, David Rientjes wrote:
> On Tue, 9 Nov 2010, Alan Cox wrote:
> 
> > The reverse can be argued equally - that they can unprotect themselves if
> > necessary. In fact it seems to be a "point of view" sort of question
> > which way you deal with CAP_SYS_RESOURCE, and that to me argues that
> > changing from old expected behaviour to a new behaviour is a regression.
> > 
> 
> I didn't check earlier, but CAP_SYS_RESOURCE hasn't had a place in the oom 
> killer's heuristic in over five years, so what regression are we referring 
> to in this thread?  These tasks already have full control over 
> oom_score_adj to modify its oom killing priority in either direction.

yes, it can control by user, but is it all system administrators will
adjust all of the processes by each one and one in real word? suppose if
it has thousands of processes in database system.

> Futhermore, the heuristic was entirely rewritten, but I wouldn't consider 
> all the old factors such as cputime and nice level being removed as 
> "regressions" since the aim was to make it more predictable and more 
> likely to kill a large consumer of memory such that we don't have to kill 
> more tasks in the near future.

the goal of oom_killer is to find out the best process to kill, the one
should be:
1. it is a most memory comsuming process in all processes
2. and it was a proper process to kill, which will not be let system 
into unpredictable state as possible.

if a user process and a process such email cleint "evolution" with
ditecly hareware access such as "Xorg", they have eat the equal memory,
so which process are you want to kill?


