Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab2A3VF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:05:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560Ab2A3VFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:05:25 -0500
Message-ID: <4F27060B.8050105@suse.cz>
Date: Mon, 30 Jan 2012 22:05:15 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 1/5] x86/jump-label: Use best default nops for inital
 jump label calls
References: <20120127201442.080360013@goodmis.org>  <20120127202030.887128048@goodmis.org> <4F230899.3020808@zytor.com> <1327697341.22710.138.camel@gandalf.stny.rr.com>
In-Reply-To: <1327697341.22710.138.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.1.2012 21:49, Steven Rostedt wrote:
> I need to find a way to get the config options of the kernel into the
> compiling of the update_jump_label.c. Then I could use the nops.h file
> with the set configs.

You can do a #include "../include/generated/autoconf.h" and you will get
the CONFIG_ definitions.


> Michal, can we get host tools to compile with the configs set by
> the .config file?

Yeah, we should simply compile all the host tools with autoconf.h and
kconfig.h included. The idea behind not doing this probably was that a
single scripts/ directory should work with multiple kernel
configurations, but this is obviously not the case.

Michal
