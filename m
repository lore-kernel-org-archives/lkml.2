Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab0IHPsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:48:23 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61511 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab0IHPsU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:48:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=F+XpAd8D+PQ2TNxYcud7E0qtJPjHe4Mv37z+XlwFjjzgePkYT0VBMN7WIc+dF6LORW
         5wbRySSyJv6xb0YRzEMQJfyxclDHRVdI+0edggNgxUFJGvU55fOF+SKXr/knwEmXZRL1
         GacGtpz889ymD4QpKxYnplUGdle+kdfGFUP2g=
MIME-Version: 1.0
In-Reply-To: <201009081728.18227.fabio@metanix.org>
References: <201009081728.18227.fabio@metanix.org>
Date: Wed, 8 Sep 2010 16:48:18 +0100
Message-ID: <AANLkTimqTH5Fqus4CvBvmJUrfC9RyijPQxcohVbGMNzG@mail.gmail.com>
Subject: Re: [process scheduler] Possible bug in context_swich()?
From: Will Newton <will.newton@gmail.com>
To: fabio de francesco <fabio@metanix.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 4:28 PM, fabio de francesco <fabio@metanix.org> wrote:
> Dear List,
>
> My previous mails to you have gone unheard... my last chance...
>
> In context_switch() (in linux/kernel/sched.c), starting with release 2.6.33,
> two "unlikely" macro  have been changed to "likely". I think the previous
> logic was right while the latter is wrong.
>
> In case I am missing something I, please, ask someone to explain the above
> mentioned inversion of logic through releases.

Hi fabio,

The logic was changed in commit
710390d90f143a9ebb87a475215140f426792efd on the basis of a branch hint
profiling run. It would guess previous logic was more likely to be
correct, unless one is often scheduling between kernel threads, but
maybe that happens more often than I expect.

I would suggest trying the branch tracer yourself if you think the
current code is wrong for your workload, the config option is
PROFILE_ANNOTATED_BRANCHES. I would suggest not profiling the boot
process (which will have predominantly kernel threads) and not
profiling on an idle system (which may also be relatively heavy on
kernel threads).
