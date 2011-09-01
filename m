Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab1IAIB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 04:01:28 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:18301 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809Ab1IAIB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 04:01:26 -0400
Message-ID: <4E5F3B25.9030701@parallels.com>
Date: Thu, 01 Sep 2011 11:58:29 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Vasiliy Kulikov <segoon@openwall.com>,
        "containers@lists.osdl.org" <containers@lists.osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Glauber Costa <glommer@parallels.com>,
        James Bottomley <jbottomley@parallels.com>, Tejun Heo <tj@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch 2/2] fs, proc: Introduce the /proc/<pid>/map_files/ directory
 v6
References: <20110831075814.003575573@openvz.org>	<20110831080229.100652529@openvz.org>	<20110831090612.GA3253@albatros>	<20110831112642.GI25465@sun>	<20110831140416.GA17626@shutemov.name>	<20110831142622.GB30615@sun> <20110831151023.5b7e12da.akpm@linux-foundation.org>
In-Reply-To: <20110831151023.5b7e12da.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm reluctant to merge something like this unless/until it has real
> use-cases.
> 
> What is the status of your c/r effort?

Working prototype that can dump and restore tree of processes with their
registers, memory of all kinds (anon/file, private/shared), open regular
files and pipes (with contents).

And we have an RFC set from Tejun that can suspend and resume a TCP connection.

> What additional kernel patches are required to bring that effort to a
> usable state and where are those patches?

* The one you've already accepted with ->statfs for pipefs.
* PTRACE_SEIZE set from Tejun (RFC was sent some time earlier)
* CLONE_USEPID flag for the clone() syscall (Cyrill will re-send a bit later)
* The binfmt handler for images (I've sent it earlier, but there's a discussion
  happening over it. We can do restore without one, but it will improve the
  situation significantly)

Once this is merged the prototype I described above starts working on the
out-of-the-box kernel.

> IOW, before starting to merge things I'd like to get an understanding
> of what *all* the patches look like and of what level of c/r
> functionality they provide.
> 
> This particular patch introduces a distressing amount of duplication of
> /proc/pid/maps.  The changelog should provide a really good
> justification for doing this: why is /proc/pid/maps (and smaps!)
> unsuitable and why cannot maps/smaps be fixed to be suitable?

This is not duplication, since with /proc/pid/s?maps you have no idea of what
file is being mapped by a vma. I mean - you know some "path" to it, but it's
not reliable at all.

Besides, without this set there's absolutely no way to find out which two 
mappings are shared and is extremely hard to restore shared mapping.

Thanks,
Pavel
