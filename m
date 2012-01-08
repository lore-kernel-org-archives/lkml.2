Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab2AHO7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 09:59:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650Ab2AHO7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 09:59:20 -0500
Message-ID: <4F09AFBD.60503@suse.cz>
Date: Sun, 08 Jan 2012 16:01:17 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Makefiles: Disable unused-variable warning
References: <1324695619-5537-1-git-send-email-kirill@shutemov.name> <20111227135752.GK5344@tiehlicka.suse.cz>
In-Reply-To: <20111227135752.GK5344@tiehlicka.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 27.12.2011 14:57, Michal Hocko napsal(a):
> Anyway, I am wondering why unused-but-set-variable is disabled while
> unused-variable is enabled.

unused-but-set-variable was disabled, because it was a new warning in
gcc 4.6 and produced too much noise relatively to its severity. A make
W=1 build of x86_64_defconfig gives:
$ grep -c 'Wunused-but-set-variable' log
77
$ grep -c 'Wunused-variable' log
0

More exotic configuration will probably result in a couple of unused
variable warnings, but that IMO no reason to disable them globally.

> Shouldn't we just disable it as well rather
> than workaround this in the code? The warning is just pure noise in this
> case.

If it's noise in a particular case, there is always the option to add

CFLAGS_memcontrol.o := $(call cc-disable-warning, unused-variable)

to the respective Makefile.

Michal
