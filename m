Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab1BOV02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 16:26:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45583
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752873Ab1BOV01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 16:26:27 -0500
Date: Tue, 15 Feb 2011 13:27:02 -0800 (PST)
Message-Id: <20110215.132702.39199169.davem@davemloft.net>
To: simoneau@ele.uri.edu
Cc: will.newton@gmail.com, hpa@zytor.com, matt@console-pimps.org,
        rostedt@goodmis.org, peterz@infradead.org, jbaron@redhat.com,
        mathieu.desnoyers@polymtl.ca, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110215211123.GA3094@ele.uri.edu>
References: <4D59B891.8010300@zytor.com>
	<AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com>
	<20110215211123.GA3094@ele.uri.edu>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Simoneau <simoneau@ele.uri.edu>
Date: Tue, 15 Feb 2011 16:11:23 -0500

> Note how the cache and cache coherence protocol are fundamental parts of this
> operation; if these instructions simply bypassed the cache, they *could not*
> work correctly - how do you detect when the underlying memory has been
> modified?

The issue here isn't L2 cache bypassing, it's local L1 cache bypassing.

The chips in question aparently do not consult the local L1 cache on
"ll" instructions.

Therefore you must only ever access such atomic data using "ll"
instructions.
