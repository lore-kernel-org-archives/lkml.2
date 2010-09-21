Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab0IURmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 13:42:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57808 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab0IURmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 13:42:03 -0400
Message-ID: <26e58eb6fd2aa699f49505a71d08813a.squirrel@www.firstfloor.org>
In-Reply-To: <4C98ECD4.5020606@zytor.com>
References: <cover.1284733808.git.jbaron@redhat.com>
    <ee8b3595967989fdaf84e698dc7447d315ce972a.1284733808.git.jbaron@redhat.com>
    <20100921131232.GA3024@one.firstfloor.org>
    <20100921143555.GA2873@redhat.com>
    <0e1f6b339e72a449fed0df7b801da607.squirrel@www.firstfloor.org>
    <1285082049.23122.1930.camel@gandalf.stny.rr.com>
    <4C98ECD4.5020606@zytor.com>
Date: Tue, 21 Sep 2010 19:42:02 +0200
Subject: Re: [PATCH 03/10] jump label v11: base patch
From: "Andi Kleen" <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Andi Kleen" <andi@firstfloor.org>,
        "Jason Baron" <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> If all you need is exact matches -- as in this case -- hashes are
> generally faster than binary anyway.

Actually only if you have the whole thing in cache. The binary
search has a much nicer access pattern if it's cache cold.

And the footprint of directly accessing the section than having
separate large list and tables is also significantly more
compared to a compact table.

But I don't think the access speed really matters here. Toggling
trace points should be rare and is not a critical path
operation. What matters is runtime overhead and simplicity.

Right now on the simplicity front there is a problem.

-Andi

