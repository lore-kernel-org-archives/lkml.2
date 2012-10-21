Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab2JUTj5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 15:39:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513Ab2JUTj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 15:39:56 -0400
Date: Sun, 21 Oct 2012 21:40:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/9] uprobes: allow ignoring of probe hits
Message-ID: <20121021194058.GA29137@redhat.com>
References: <1350242593-17761-1-git-send-email-rabin@rab.in> <1350242593-17761-3-git-send-email-rabin@rab.in> <20121015165218.GA10239@redhat.com> <CAH+eYFBHXAWTinnVO8vEnEhFDQLibwo+BtxYJJYdPcG9__n5OQ@mail.gmail.com> <20121017173510.GA11019@redhat.com> <20121021181504.GA4840@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121021181504.GA4840@ubuntu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21, Rabin Vincent wrote:
>
> On Wed, Oct 17, 2012 at 07:35:10PM +0200, Oleg Nesterov wrote:
> >
> > And, to clarify, I am not arguing. Just curious.
> >
> > So, is this like cmov on x86? And this patch allows to not report if
> > the condition is not true? Or there are other issues on arm?
>
> Yes, I guess this is like CMOV on x86.  In the ARM instruction set most
> instructions can be conditionally executed.
>
> In order to set the probe on a conditional instruction, we use an
> undefined instruction with the same condition as the instruction we
> replace.  However, it is implementation defined whether an undefined
> instruction with a failing condition code will trigger an undefined
> instruction exception or just be executed as a NOP.  So for those
> processor implementations where we do get the undefined instruction
> exception even for a failing condition code, we have to ignore it in
> order to provide consistent behaviour.

OK, I see, thanks for your explanation.

Oleg.

