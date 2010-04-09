Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab0DIVdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 17:33:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757144Ab0DIVdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 17:33:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       rth@redhat.com, mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 7/9] jump label: sort jump table at build-time
In-Reply-To: Vivek Goyal's message of  Friday, 9 April 2010 17:24:25 -0400 <20100409212425.GB8219@redhat.com>
References: <cover.1270839564.git.jbaron@redhat.com>
	<9cd6a0307ac55f2090c5b75a26ee9ca6a167cc8d.1270839564.git.jbaron@redhat.com>
	<20100409212425.GB8219@redhat.com>
X-Windows: ignorance is our most important resource.
Message-Id: <20100409213249.BDEF9CD14@magilla.sf.frob.com>
Date: Fri,  9 Apr 2010 14:32:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think it just happens to come out harmless.  The relocs.c extraction
stuff doesn't actually care about the exact address to be relocated, it
only needs to know that a relocated value sits at a given place in the
binary.  The sorting rearranges the addresses in the text without
rearranging their corresponding relocs, but it's still the case that at
exactly each of those spots in text there is a relocated address.  The
boot-time "relocation" is just a blind adjustment to all those spots,
without reference to the original relocation details.  So it Just Works.
I'm not at all sure this is how we want things to be.  It's rather
nonobvious and fragile if we change any of the related magic.  But I think
it is entirely reliable in today's code that it will do the right thing.


Thanks,
Roland
