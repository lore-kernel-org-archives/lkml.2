Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab2AaKju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:39:50 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53462 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab2AaKjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:39:48 -0500
MIME-Version: 1.0
In-Reply-To: <4F278A78.8080300@gmail.com>
References: <1327830093-12130-1-git-send-email-namhyung@gmail.com>
	<4F263B01.4050103@gmail.com>
	<20120130170548.GA3355@google.com>
	<4F278A78.8080300@gmail.com>
Date: Tue, 31 Jan 2012 02:39:47 -0800
X-Google-Sender-Auth: XsxnrXnxtmH_XB4Ud2vIeBoCiJE
Message-ID: <CAOS58YP1F6_yBxRArcP4oyzAJVArLJB-ckjdXU35U1SNwi75XQ@mail.gmail.com>
Subject: Re: [PATCH] block: add missing block_bio_complete() tracepoint
From: Tejun Heo <tj@kernel.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 30, 2012 at 10:30 PM, Namhyung Kim <namhyung@gmail.com> wrote:
> Right, but the point is it could make a NULL pointer dereference during
> evaluation of the argument of the TP AFAICS. I'm not sure about the TP
> implementation though, I think I was wrong - T_E_C() cannot protect us from
> it because it happens just before jumping to the TP, right?
>
> So I think we need a conditional jump (with the "likely" annotation) for
> this even when the TP is disabled.

Hmmm... still not following. Where the said NULL dereference happen?
TEC conditional is equivalent to "if (COND) TP;".  If you don't use
TEC, it'll be "if (COND) if (TP enabled) TP;".  With TEC, it will be
"if (TP enabled) if (COND) TP;".  There's no other difference.

Thanks.

-- 
tejun
