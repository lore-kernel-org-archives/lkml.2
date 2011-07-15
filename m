Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab1GOPyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:54:52 -0400
Received: from mail.perches.com ([173.55.12.10]:4018 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab1GOPyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:54:51 -0400
Subject: Re: [PATCH 03/11] dynamic_debug: Remove uses of KERN_CONT in
 dynamic_emit_prefix
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, gregkh@suse.de, jim.cromie@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110715150734.GA2493@redhat.com>
References: <cover.1310657068.git.jbaron@redhat.com>
	 <07ef9de13b16d5c50bc36f8c8d9a9aa28a05f2ca.1310657068.git.jbaron@redhat.com>
	 <CAO+b5-qQ452VojorX_p4W2orh4DKnM206TA3F5yA2fnhcPhXsQ@mail.gmail.com>
	 <20110715150734.GA2493@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 08:54:50 -0700
Message-ID: <1310745290.7582.40.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 11:07 -0400, Jason Baron wrote:
> On Fri, Jul 15, 2011 at 12:04:22PM +0200, Bart Van Assche wrote:
> > On Thu, Jul 14, 2011 at 6:09 PM, Jason Baron <jbaron@redhat.com> wrote:
> > > +       char tid[sizeof(int) + sizeof(int)/2 + 4];
> > > +       char lineno[sizeof(int) + sizeof(int)/2];
> > It's not clear to me where the array bounds come from ? Also, why
> > sizeof(int) + sizeof(int)/2 instead of sizeof(int)*3 + 1 ?
> hmmm...for the tid it bounded by PID_MAX_LIMIT, which is 4 million, so
> you need 7 characters + 3 for the brackets and space = 10. So that looks
> right to me. Although I'm not sure where the sizeof() comes from? Joe?

It's incorrect.

sizeof(int) => # decimal digits + terminating 0
4 => 11
8 => 21

I think I meant to type sizeof(int) * 2 + sizeof(int) / 2 + 1

> For the lineno, it is 24 bits, so it can be 2^24 = 16,777,216, or 8
> characters, so I think the 6 is incorrect. Although, in practice I don't
> think we have any files that are that big.

Then the tid size should be based on PID_MAX_LIMIT.
I don't much care.
I just wanted to minimize stack consumption.

