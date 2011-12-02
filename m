Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab1LBOhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 09:37:17 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:15744 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab1LBOhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 09:37:15 -0500
Message-ID: <4ED8E296.3070005@parallels.com>
Date: Fri, 02 Dec 2011 18:37:10 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Pedro Alves <pedro@codesourcery.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [rfc 2/3] fs, proc: Introduce the Children: line in /proc/<pid>/status
References: <20111129191252.769160532@openvz.org> <201112021400.42762.pedro@codesourcery.com> <4ED8DDE4.8040609@parallels.com> <201112021425.44897.pedro@codesourcery.com>
In-Reply-To: <201112021425.44897.pedro@codesourcery.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2011 06:25 PM, Pedro Alves wrote:
> On Friday 02 December 2011 14:17:08, Pavel Emelyanov wrote:
> 
>> O_O   OK, I was wrong, they do live there. But I consider this as bug.
> 
> You can't change that.  It'd break current gdb at least.

OMG!

>> I.e. each task will be shown multiple times, which is not very fun, but memory exhaustive from my POV.
> 
> Now that is a good argument against hard linking.  But not if you make
> the entries under children/ symlinks.  Then find doesn't recurse.  And
> then 
> 
> $ find -L /proc/PID/
> 
> does recurse and give you the whole tree.  Which I'd say is
> actually useful...

It is useful, but the /proc/pid/children file solves the same problem in a much
more simple way. The memory usage by proc (one file vs one dir and a set of files)
is less and time to lookup a child is also less (read + lookup vs readdir + lookup 
(symlink itself) + lookup (symlink resolve)).

Yes, it doesn't allow you to have fun with find, but frankly, do you really need
this? Even if we're talking about gdb -- reading /proc/pid/children is not harder
and not easier than readdir-ing it.

IOW - what's the real benefit of a directory with symlinks against a file except
for a fun?

Thanks,
Pavel
