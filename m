Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab0LFN4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 08:56:44 -0500
Received: from THUNK.ORG ([69.25.196.29]:36118 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119Ab0LFN4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 08:56:43 -0500
Date: Mon, 6 Dec 2010 08:56:37 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Sharp <dhsharp@google.com>, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, mrubin@google.com
Subject: Re: [Patch 00/15] Reduce tracing payload size.
Message-ID: <20101206135637.GC8135@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>, David Sharp <dhsharp@google.com>,
	rostedt@goodmis.org, linux-kernel@vger.kernel.org,
	mrubin@google.com
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
 <878w03t4sn.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878w03t4sn.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 02:22:00PM +0100, Andi Kleen wrote:
> David Sharp <dhsharp@google.com> writes:
> >
> > These patches are just a start to shrinking the size of trace events. I am
> > planning to also make small versions of trace events that are used when
> > CONFIG_SMALL_TRACES is enabled. I'm also open to discussion of other ways to
> > shrink event sizes.
> 
> Maybe the simplest would be to lzo them as they get logged?
> I assume you already considered that?

The tracing subsystem is supposed to be extremely low-overhead.
Compressiong the event log would add considerable CPU overhead.  If we
can shrink the trace events by being more careful about unnecessary
padding, and not logging fields that aren't needed, it's all win....

The problem of course with the latter is that different people will
have disagreements about what is needed or not.  And even adding
conditionals will slow down the tracing hotpath.

						- Ted
