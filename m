Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902Ab2INLnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:43:39 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33880 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab2INLnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:43:35 -0400
Date: Fri, 14 Sep 2012 13:36:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        peterz@infradead.org, Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH 3/3 v2] perf tool: give user better message if precise is
 not supported
Message-ID: <20120914113617.GA13299@gmail.com>
References: <1347569955-54626-1-git-send-email-dsahern@gmail.com>
 <1347569955-54626-4-git-send-email-dsahern@gmail.com>
 <20120914054344.GB9043@gmail.com>
 <50531151.9020202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50531151.9020202@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 9/13/12 11:43 PM, Ingo Molnar wrote:
> >>v2: softened message to 'may not be' supported per Robert's suggestion
> >
> > Well, either it's supported on this machine or it's not - 
> > why does the text have to be so unsure about it?
> 
> Because EOPNOTSUPP is returned for more than just precise 
> mode. We cannot say with certainty that the precise attribute 
> caused that errno.

Well, then that is useful information we *lost*, and that 
situation needs to be improved on the ABI side: an expanded 
error code present in the event structure, copied back to 
user-space on errors, or so.

(Alternatively, a special event channel just to pass back 
expanded error conditions.)

Computers are supposed to make life easier for humans, by 
answering such "what did go wrong?" questions. Our losing of 
precise error conditions is a usability bug really - and in the 
perf project we are in a unique position to be able to improve 
both the kernel side code and make immediate use of it on the 
tooling side as well.

Thanks,

	Ingo
