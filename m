Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab1HGJbF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 05:31:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38431 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab1HGJbB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 05:31:01 -0400
MIME-Version: 1.0
In-Reply-To: <20110807073916.GA13298@mtj.dyndns.org>
References: <1312614073-11516-1-git-send-email-rabin@rab.in>
 <20110806080323.GB23937@htj.dyndns.org> <20110806163837.881d70af.akpm@linux-foundation.org>
 <20110807073916.GA13298@mtj.dyndns.org>
From: Rabin Vincent <rabin@rab.in>
Date: Sun, 7 Aug 2011 15:00:20 +0530
X-Google-Sender-Auth: FDw-CH5AWkdjACTRODfS6ML9D6E
Message-ID: <CAH+eYFAfCSVjf=dbfJn=kUyWQ8v7him7jLnKkPM33qGxb_nj3A@mail.gmail.com>
Subject: Re: [PATCH] stop_machine: build unconditionally if SMP
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 7, 2011 at 13:09, Tejun Heo <tj@kernel.org> wrote:
> On Sat, Aug 06, 2011 at 04:38:37PM -0700, Andrew Morton wrote:
>> The priority is unclear.  It appears that the patch fixes a build error
>> under sone circumstances in current mainline?
>
> I don't think it would have triggered build error as there are dummy
> functions which just calls the function on the local CPU, but it does
> look pretty broken now.  e.g. ia64 supports memory hotplug which
> depends on stop machine but it would still be using dummy local
> version, which can't be right.

Right.  Although I guess most people build with MODULE_UNLOAD enabled,
so wouldn't hit the problem.

> Robin, is there an open bug report regarding this issue?  I'm not sure
> enough to suggest -stable but definitely mainline material.

There's no bug report.  I noticed it because I sometimes build ARM
kernels with module support and HOTPLUG_CPU disabled.
