Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab1GNAvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 20:51:44 -0400
Received: from mail.perches.com ([173.55.12.10]:3996 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab1GNAvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 20:51:43 -0400
Subject: Re: best way to handle multi-line kernel messages
From: Joe Perches <joe@perches.com>
To: david@lang.hm
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1107131723410.16335@asgard.lang.hm>
References: <alpine.DEB.2.02.1107131723410.16335@asgard.lang.hm>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jul 2011 17:51:41 -0700
Message-ID: <1310604701.1662.55.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-13 at 17:30 -0700, david@lang.hm wrote:
> a query was made on the rsyslog mailing list about the possibility of 
> rsyslog handling kernel messages better. Currently each line of logs is a 
> separate log entry (and as log entries traverse networks there are thigns 
> taht can cause them to get re-ordered). It would be nice to be able to 
> combine multi-line logs into one log entry.
> 
> The problem is figuring out how to tell when one log entry finishes and 
> the next starts.
> 
> >From examining logs it looks like follow-up lines are frequently (but not 
> always) indented with some form of whitespace (this indentation taking 
> place after the timestamp if that's enabled)
> but this is not consistantly the case.

No, not at all.  Most follow-on lines are pr_cont.

> I suspect that there is not currently any good way for something to really 
> tell when one log entry has finished and another is starting,

There isn't.

> but I wanted 
> to ask here if there is anything that I should be able to rely on (with 
> the thought that fixing log messages that don't work that way coudl be 
> somethign for -janitors or newbes to work on)

you'll have to implement something like:

pr_start(&cookie);
pr_multi_<level>(cookie, fmt, ...);
pr_multi_cont(cookie, fmt, ...);
pr_end(cookie);

> or is this a completely hopeless task that people receiving logs should 
> not even try to do?

There really aren't _that_ many places where
multiple calls to printk/pr_level are made.

