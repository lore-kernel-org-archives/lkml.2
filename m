Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab1INQQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 12:16:25 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:40298 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab1INQQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 12:16:23 -0400
Message-ID: <4E70D29D.20104@parallels.com>
Date: Wed, 14 Sep 2011 20:13:17 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm00@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "containers@lists.osdl.org" <containers@lists.osdl.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Kirill Shutemov <kirill@shutemov.name>,
        James Bottomley <jbottomley@parallels.com>,
        Nathan Lynch <ntl@pobox.com>, Zan Lynx <zlynx@acm.org>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, Tejun Heo <tj@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/2] fs, proc: Introduce the /proc/<pid>/map_files/ directory
 v12
References: <20110913211359.674453213@openvz.org> <20110913212447.918816776@openvz.org> <20110913235222.043927b3.akpm@linux-foundation.org> <20110914105607.GP25367@sun> <20110914111437.GA22516@atrey.karlin.mff.cuni.cz> <20110914113912.GQ25367@sun> <20110914134405.GV25367@sun> <20110914144841.GA7906@albatros> <20110914160018.GW25367@sun> <20110914160724.GA10612@albatros>
In-Reply-To: <20110914160724.GA10612@albatros>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No, I mean something else.  Assume you have a task, which does the
> steps:
> 
> 1) opens some sensitive file as root.  This file is e.g. 0700.
> 
> 2) mmaps the file via opened fd, either RO or RW.
> 
> 3) closes fd.
> 
> 4) drops root.
> 
> Now it has a mapping of a privileged file, but cannot get fd of it
> anyhow.  With map_files/ he may open his own /proc/$$/map_files/, pass
> ptrace() check, and get fd of the privileged file.  He cannot explicitly
> open it as it is 0700, but he may open it via map_files/ and get RO/RW
> fd.
> 

What is the problem here - the fact that we have some file considered to
be private be open-able by somebody else, or the fact that we can truncate
the file being mapped?

If the fist issue stands, then it also stands for /proc/pid/fd and thus we
don't introduce the new problem.

If the second, then it's not a problem as mm can handle this already.

Thanks,
Pavel
