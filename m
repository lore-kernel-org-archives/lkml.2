Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab1LBOpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 09:45:45 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:43747 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab1LBOpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 09:45:43 -0500
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [rfc 2/3] fs, proc: Introduce the Children: line in /proc/<pid>/status
Date: Fri, 2 Dec 2011 14:45:36 +0000
User-Agent: KMail/1.13.6 (Linux/2.6.38-13-generic; KDE/4.7.2; x86_64; ; )
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>
References: <20111129191252.769160532@openvz.org> <201112021425.44897.pedro@codesourcery.com> <4ED8E296.3070005@parallels.com>
In-Reply-To: <4ED8E296.3070005@parallels.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112021445.37024.pedro@codesourcery.com>
X-OriginalArrivalTime: 02 Dec 2011 14:45:39.0480 (UTC) FILETIME=[0F302980:01CCB101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 December 2011 14:37:10, Pavel Emelyanov wrote:
> On 12/02/2011 06:25 PM, Pedro Alves wrote:
> > On Friday 02 December 2011 14:17:08, Pavel Emelyanov wrote:
> > 
> >> O_O   OK, I was wrong, they do live there. But I consider this as bug.
> > 
> > You can't change that.  It'd break current gdb at least.
> 
> OMG!

You know, NPTL didn't exist on earlier kernels.  This preserved
backwards compatibility.

> >> I.e. each task will be shown multiple times, which is not very fun, but memory exhaustive from my POV.
> > 
> > Now that is a good argument against hard linking.  But not if you make
> > the entries under children/ symlinks.  Then find doesn't recurse.  And
> > then 
> > 
> > $ find -L /proc/PID/
> > 
> > does recurse and give you the whole tree.  Which I'd say is
> > actually useful...
> 
> It is useful, but the /proc/pid/children file solves the same problem in a much
> more simple way. The memory usage by proc (one file vs one dir and a set of files)
> is less and time to lookup a child is also less (read + lookup vs readdir + lookup 
> (symlink itself) + lookup (symlink resolve)).
> 
> Yes, it doesn't allow you to have fun with find, but frankly, do you really need
> this? Even if we're talking about gdb -- reading /proc/pid/children is not harder
> and not easier than readdir-ing it.
> 
> IOW - what's the real benefit of a directory with symlinks against a file except
> for a fun?

As I said on the first message, it's easier on the command line, likely for
quick scripting too.  And for consistency.  gdb or whatever other software
can of course do whatever programatically.  But if I can't persuade you guys
that's a good thing, fine.

-- 
Pedro Alves
