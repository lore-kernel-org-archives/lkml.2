Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab1BKWVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 17:21:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45453 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757159Ab1BKWVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 17:21:03 -0500
Message-ID: <4D55B5E8.2040306@zytor.com>
Date: Fri, 11 Feb 2011 14:19:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <cover.1294239591.git.jbaron@redhat.com> <1297452328.5226.89.camel@laptop> <BLU0-SMTP101B686C32E10BA346B15F896EF0@phx.gbl> <1297460297.5226.99.camel@laptop> <20110211221550.GA9148@redhat.com>
In-Reply-To: <20110211221550.GA9148@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2011 02:15 PM, Jason Baron wrote:
> 
> a bit of history...
> 
> For the disabled jump label case, we didn't want to incur an atomic_read() to
> check if the branch was enabled.
> 
> So, I separated the API, to have one for the non-atomic case, and one
> for the atomic case. Nobody liked that.
> 
> So now, I'm proposing to leave the core API based around a non-atomic
> variable, and have any callers that want to use this atomic interface,
> to call into the non-atomic interface. If another user besides perf
> wants to use the same type of atomic interface, we can re-visit the
> decsion? 
> 

What is the problem with taking the atomic_read()?

	-hpa
