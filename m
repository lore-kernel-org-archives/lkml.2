Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab2CVQdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 12:33:36 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:32957 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758559Ab2CVQdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 12:33:35 -0400
Message-ID: <1332434013.1946.10.camel@joe2Laptop>
Subject: Re: [PATCH 1/1] checkpatch.pl: thou shalt not use () or (...) in
 function declarations
From: Joe Perches <joe@perches.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>, apw@canonical.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org
Date: Thu, 22 Mar 2012 09:33:33 -0700
In-Reply-To: <CAFLxGvyaz7SgV1BaLdC5uKMq_LTgFDHCiO+YReKdE4h7Ebi59A@mail.gmail.com>
References: <1332430038-21057-1-git-send-email-ext-phil.2.carmody@nokia.com>
	 <CAFLxGvyaz7SgV1BaLdC5uKMq_LTgFDHCiO+YReKdE4h7Ebi59A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 16:49 +0100, richard -rw- weinberger wrote:
> On Thu, Mar 22, 2012 at 4:27 PM, Phil Carmody
> <ext-phil.2.carmody@nokia.com> wrote:
> > After HPA's wonderful lkml post, referenced, it seems worth trying to
> > detect this robomatically.
> 
> See:
> http://marc.info/?l=linux-kernel&m=133193918813599

But Phil's test is better because it also
tests for function declarations on multiple
lines like

type
foo(...)

		if ($ctx =~ /((\b$Type\s+$Ident)\s*\(\s*(?:\.\.\.)?\s*\))/) {

The ERROR needs updating for a --ignore type though.
Something like this may be better.

		ERROR("FUNCTION_NO_PROTOTYPE",
		      "Bad function definition - $1 should probably be $2(void)\n" .
		      herecurr);

And I think the screed funny once but not useful.


