Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab2BWRLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:11:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56570 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab2BWRLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:11:06 -0500
Message-ID: <4F467305.3030901@zytor.com>
Date: Thu, 23 Feb 2012 09:10:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Steven Rostedt <rostedt@goodmis.org>, a.p.zijlstra@chello.nl,
        mathieu.desnoyers@efficios.com, davem@davemloft.net,
        ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
References: <cover.1329851692.git.jbaron@redhat.com> <4F43F9F0.4000605@zytor.com> <20120221202019.GB2381@redhat.com> <1329856745.25686.72.camel@gandalf.stny.rr.com> <20120222073251.GB17291@elte.hu> <20120222075334.GA25053@elte.hu> <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com> <20120222081855.GB25318@elte.hu> <20120222213343.GA19758@bloggs.ozlabs.ibm.com> <20120223100205.GD24310@elte.hu> <20120223162158.GA2401@redhat.com>
In-Reply-To: <20120223162158.GA2401@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2012 08:21 AM, Jason Baron wrote:
> 
> So, we could get rid of the '&' with something as simple as:
> 
> #define very_unlikely(key) __very_unlikely(&key)
> 
> However, it does seem potentially more error prone, b/c if 'key' is
> passed to a function, and they we do the very_unlikely() we end up with
> the address parameter (due to pass by value). That said, it doesn't look
> like anybody is using very_unlikely() in that manner in the tree, and we
> could document the usage.
> 

The normal way to do this is to make the type an array of size 1.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

