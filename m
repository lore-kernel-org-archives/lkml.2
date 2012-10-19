Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab2JSKnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:43:08 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:64433 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab2JSKnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:43:06 -0400
Subject: Re: [PATCH v4] posix timers: allocate timer id per process
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@openvz.org" <devel@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>
In-Reply-To: <50811FA6.8000709@parallels.com>
References: <20121019074912.10745.339.stgit@localhost.localdomain>
	 <1350633401.2293.245.camel@edumazet-glaptop>
	 <50811FA6.8000709@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Oct 2012 12:43:03 +0200
Message-ID: <1350643383.2293.436.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-19 at 13:38 +0400, Stanislav Kinsbursky wrote:
> 19.10.2012 11:56, Eric Dumazet пишет:
> > I wonder if some applications relied on our idr, assuming they would get
> > low values for their timer id.
> > (We could imagine some applications use a table indexed by the timer id)
> 
> Hmm.
> Probably, this particular case can be optimised by tuning min_id to id of 
> releasing timer (if id of this timer is less than current->signal min_id).
> Does this approach solves the issue you mentioned above?

Not generally, but I am not sure we want a per signal_struct idr ;)

Really that should be clearly explained in the changelog, so that buggy
applications can have a clue of what happened.

When we changed UDP source port selection being random instead of
sequential, maybe this broke some applications. That was an
implementation choice (with security impact).



