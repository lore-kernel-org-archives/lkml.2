Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220Ab1IWRmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 13:42:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35223 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750724Ab1IWRmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 13:42:18 -0400
Subject: Re: [PATCH 25/26] dynamic_debug: add pr_fmt_dbg() for
 dynamic_pr_debug
From: Joe Perches <joe@perches.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: jim.cromie@gmail.com, jbaron@redhat.com, greg@kroah.com,
        linux-kernel@vger.kernel.org
Date: Fri, 23 Sep 2011 10:42:13 -0700
In-Reply-To: <CAO+b5-qTB2YW4rpS-sGqgXhFWeaEYrM4k87RonmdAz-2t6asCg@mail.gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
	 <1316642115-20029-26-git-send-email-jim.cromie@gmail.com>
	 <1316725066.29447.16.camel@Joe-Laptop>
	 <CAO+b5-qTB2YW4rpS-sGqgXhFWeaEYrM4k87RonmdAz-2t6asCg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.91- 
Content-Transfer-Encoding: 7bit
Message-ID: <1316799737.5266.32.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending with minor additions, first email hasn't shown up in 4+ hours)

On Fri, 2011-09-23 at 12:31 +0200, Bart Van Assche wrote:
> On Thu, Sep 22, 2011 at 10:57 PM, Joe Perches <joe@perches.com> wrote:
> > Maybe add all the pr_<level> variants too because
> > some like to prefix __func__ to pr_err but not pr_info
> > etc.
> Hi Joe,

Hi Bart.

> Are you sure it makes sense to introduce all these new macros ?
> Introducing pr_fmt_dbg() makes sense to me, but the usefulness of the
> macros proposed above is not clear to me.

Probably the most useful application of
pr_fmt_debug would be to prefix __func__ to
debug output but not to other pr_<level> uses.

dynamic_debug would not be able to detect that
__func__ duplication except by using vscnprintf
to a buffer and checking the initial output.

Perhaps a simpler way to avoid duplication of
KBUILD_MODNAME ":" in dynamic_debugging is to
scan the fmt string and move the fmt pointer
past any leading KBUILD_MODNAME ": " when
appropriate.

I think these pr_fmt_<level> macros have a
relatively low overall value but I prefer
comprehensive implementations rather than
partial ones.

There are a couple of modules where people
prefix __func__ to pr_err but not pr_info.

e.g.: drivers/net/ethernet/broadcom/cnic.c

Adding all the #define pr_fmt_<level>s could
simplify that.

cheers, Joe

