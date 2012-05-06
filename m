Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab2EFNiR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 09:38:17 -0400
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:58088 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751647Ab2EFNiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 09:38:16 -0400
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 May 2012 09:38:15 EDT
Date: Sun, 6 May 2012 15:28:27 +0200
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Renato Westphal <renatowestphal@gmail.com>
Cc: Zhihua Che <zhihua.che@gmail.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: How can I turn off/disable -O2/-Os optimization?
Message-ID: <20120506132827.GB3824@nuttenaction>
References: <CABexPfEdd0k9UGTJL9Ae5B=e_dDZMsTGg-LNYrOjLKzHBxuPwg@mail.gmail.com>
 <4F788731.8020708@xenotime.net>
 <CABexPfHsNB1-v34vG3tW3VCLw=mWeBFoY+7Ko2174q9wK7Wh-Q@mail.gmail.com>
 <CAChaegmgw_8KsmOAt=WpHN6KTa9qkgh-EmHC-PGqCQxGRQ2U6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAChaegmgw_8KsmOAt=WpHN6KTa9qkgh-EmHC-PGqCQxGRQ2U6w@mail.gmail.com>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Renato Westphal | 2012-05-05 23:00:48 [-0300]:

>>> You could try the new CONFIG_READABLE_ASM patch:
>>>  http://marc.info/?l=linux-kernel&m=133296079716268&w=2

Maybe remove "-Os" on a global basis is not wanted nor required. Maybe a per
directory, per file or per function basis may superior!

make DISABLE_OPTIMIZATION=net/sched/sch_api.c

But still all core constructs defined in top level header files must be
compatible for directory/file basis to be build with no optimization at all.

One way to un-optmize fine-granular is GCC's optmize pragma [1].

Hagen

PS: such a functionality may be convenient for perf probe too! (to hook into
probepoints which are currently optimized out)


[1] http://gcc.gnu.org/onlinedocs/gcc/Function-Specific-Option-Pragmas.html
