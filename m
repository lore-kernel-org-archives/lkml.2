Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349Ab2IMPuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:50:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758321Ab2IMPuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:50:50 -0400
Date: Thu, 13 Sep 2012 17:52:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [PATCH 2/2] coredump: add a new elf note with siginfo fields
	of the signal
Message-ID: <20120913155259.GA2267@redhat.com>
References: <1347493124-10661-1-git-send-email-vda.linux@googlemail.com> <1347493124-10661-2-git-send-email-vda.linux@googlemail.com> <20120913153615.GB32128@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913153615.GB32128@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

forgot to mention...

On 09/13, Oleg Nesterov wrote:
>
> Not sure this is right. I think fill_siginfo_note() should either do
> memcpy() and let userspace to decode this (raw) info, or this layout
> should be unified with copy_siginfo_to_user().

And note that we simply do not know what this siginfo contains if
si_code < 0. Again, please look at copy_siginfo_to_user().

> Note also that we do not expose the upper bits of si_code to user-space,
> probably coredump should do the same, I dunno.

If it was sent by kernel, I meant.

Oleg.

