Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab2HROwh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 10:52:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47732 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab2HROwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 10:52:33 -0400
MIME-Version: 1.0
In-Reply-To: <201208181538.59940.rjw@sisk.pl>
References: <1345212420-1707-1-git-send-email-ming.lei@canonical.com>
	<201208180002.26563.rjw@sisk.pl>
	<CACVXFVNVvponQD85o4RHxF9e+JRtq-AX5kZOuxvETDSGktit5A@mail.gmail.com>
	<201208181538.59940.rjw@sisk.pl>
Date: Sat, 18 Aug 2012 22:52:31 +0800
Message-ID: <CACVXFVMxGCGJ+a=rfcCAqRuUMLG9OD3X52MMzTcfYOT4cepBGQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] PM / Sleep: introduce dpm_for_each_dev
From: Ming Lei <ming.lei@canonical.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 9:38 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> My question was about the number of current users of it.  Sorry for not
> being clear.

Sorry for misunderstanding your question.

>
> If there are no more anticipated users than the current only one, please
> drop the unused (void *) argument.  We can always extend it in the future
> if need be and for now passing that NULL every time is just pointless.

One usage is to get statistics info about devices for debug purpose,
so the parameter is needed to return something.

> And please fold [2/3] into [3/3] in this series.

IMO, it is better to split them to avoid coupling between fw loader and
device PM.

Looks you agreed on the patch, and Greg has added the
patch into his driver-core next tree to fix -next build failure, so could
you just let them be that?

>
> I'm not particuarly fond of this patch, but I guess it would require some
> consderable juggling of #ifdefs to fix the build breakage in a different way.

Firmware loader might be built as module, so without exporting something
from device PM core, the problem can't be fixed.


Thanks,
--
Ming Lei
