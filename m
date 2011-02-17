Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1BQDUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 22:20:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44899 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab1BQDUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 22:20:38 -0500
Message-ID: <4D5C93B6.5020900@zytor.com>
Date: Wed, 16 Feb 2011 19:19:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Will Newton <will.newton@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Will Simoneau <simoneau@ele.uri.edu>,
        David Miller <davem@davemloft.net>, matt@console-pimps.org,
        peterz@infradead.org, jbaron@redhat.com, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, fweisbec@gmail.com, avi@redhat.com, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <4D59B891.8010300@zytor.com> <AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com> <20110215211123.GA3094@ele.uri.edu> <20110215.132702.39199169.davem@davemloft.net> <20110215215604.GA3177@ele.uri.edu> <AANLkTikXy+AJ3tdEkEN--xJPefbXJ4-OVS3cg6R7yXzc@mail.gmail.com> <1297858734.23343.138.camel@gandalf.stny.rr.com> <AANLkTinzr6rb=WwFs7QApsvdy5f7PHZ1qS9ZVrncEzZD@mail.gmail.com> <BLU0-SMTP80F56386E7E060A3B2020B96D20@phx.gbl> <4D5C8019.70301@hitachi.com>
In-Reply-To: <4D5C8019.70301@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2011 05:55 PM, Masami Hiramatsu wrote:
> 
> Hmm, I think that is miss-coding ll/sc.
> If I understand correctly, usually cache invalidation should be done
> right before storing value, as MSI protocol does.
> (or, sc should atomically invalidate the cache line)
> 

I suspect in this case one should flush the cache line before ll (a
cache flush will typically invalidate the ll/sc link.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

