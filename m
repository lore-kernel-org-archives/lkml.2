Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab0IVUHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 16:07:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51237 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665Ab0IVUHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 16:07:09 -0400
Message-ID: <4C9A61AE.3080804@zytor.com>
Date: Wed, 22 Sep 2010 13:06:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>, jbaron@redhat.com, rostedt@goodmis.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] Rewrite jump_label.c to use binary search
References: <1285150102-5506-1-git-send-email-andi@firstfloor.org> <1285150102-5506-2-git-send-email-andi@firstfloor.org> <4C9A2AED.3050801@zytor.com> <20100922194331.GB28463@Krystal>
In-Reply-To: <20100922194331.GB28463@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 12:43 PM, Mathieu Desnoyers wrote:
> * H. Peter Anvin (hpa@zytor.com) wrote:
>> On 09/22/2010 03:08 AM, Andi Kleen wrote:
> 
> That's a very interesting idea, which applies very well to exception
> handlers, but tracepoints and static jumps suffer from the problem that
> there are many possible instances of the same key.
> 
> Tracepoints use a lookup by tracepoint name. Static jumps use a lookup
> by associated variable address (but this variable can be associated with
> many instances, e.g. in the case of static inline functions, or just
> when the same variable is used to control many instances of static
> jumps).
> 
> But maybe we could find a way to do an initial sort phase, so the
> perfect hash could point to the first entry corresponding to the looked
> up key ?
> 

In the case of multiple instances of the same key you want the perfect
hash to point to the cluster of solutions -- a list.  Since this is by
necessity something that needs to be done at compile time that list can
simply be an array.

	-hpa
