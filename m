Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab2AYPaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 10:30:06 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58200 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2AYPaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 10:30:04 -0500
Date: Wed, 25 Jan 2012 19:29:58 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] fs, proc: Introduce /proc/<pid>/task/<tid>/children
 entry v8
Message-ID: <20120125152958.GA7888@moon>
References: <20120123142436.181674896@openvz.org>
 <20120124110730.a3536647.kamezawa.hiroyu@jp.fujitsu.com>
 <20120124065338.GB29735@moon>
 <20120124160709.e05c51b5.kamezawa.hiroyu@jp.fujitsu.com>
 <20120124072122.GD29735@moon>
 <m1boptmqj0.fsf@fess.ebiederm.org>
 <20120124091135.GI29735@moon>
 <4F1F576A.9090102@gmail.com>
 <m1r4yoedkm.fsf@fess.ebiederm.org>
 <20120125065551.GD2005@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120125065551.GD2005@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 10:55:51AM +0400, Cyrill Gorcunov wrote:
> > 
> > Now that you have reminded me of this thread.  I can say that the
> > link would need to look like ../../pid.  Our children will always
> > be thread group leaders, so we can safely point to the /proc/<pid>
> > directories.  So readlink would return ../../<pid> or however many
> > dots are needed.  Follow link could just warp us to that directory
> > as it does for the other magic proc symlinks.
> > 
> > My feeling is that a children subdirectory would be a lot more useful
> > than a simple file that lists the children.
> > 
> 
> I'll check what I can do, thanks.
> 

Sigh. This will require complete code rewrite. And since I've just
made it to live under CONFIG_CHECKPOINT_RESTORE I would prefer if
we stick with children file. So if there are no strong objections
agains 'children' as a file, could we leave it as is, ie in
stream-of-pids form?

	Cyrill
