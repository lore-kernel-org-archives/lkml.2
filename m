Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab2FEQrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:47:12 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45133 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab2FEQrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:47:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120605110541.GC13495@aftab.osrc.amd.com>
References: <20120531153512.GK14515@aftab.osrc.amd.com> <20120531154224.GL14515@aftab.osrc.amd.com>
 <20120601110647.2c446aa7@rockpopper> <20120605110541.GC13495@aftab.osrc.amd.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Jun 2012 09:46:49 -0700
X-Google-Sender-Auth: U-iKGh_rHIZWwemn1TGnQA1TMpc
Message-ID: <CA+55aFxu9ZfbKuWdhmADreRS9wxzMyW9buoVkd=B4Yqi=bxbiw@mail.gmail.com>
Subject: Re: [PATCH] CMA: Do no enable it by default
To: Borislav Petkov <bp@amd64.org>
Cc: Christopher Yeoh <cyeoh@au1.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 4:05 AM, Borislav Petkov <bp@amd64.org> wrote:
>
> Besides, in the config option it says "... which allow a process with
> the correct privileges to directly read from or write to to another
> process's address space.", which, if the reading process has somehow
> gained privileges (as that never happens) is your security issue right
> there.

What?

It's using the same privileges as ptrace. If you are allowed to ptrace
somebody, there's no security issue.

Also, the reason it's "default y" is that the feature actually made it
in earlier (with no config option at all). Now, I certainly agree that
we could turn it off by default since it's not that common, but at the
same time none of your actual commit comments make sense, so that
would have to be fixed first.

            Linus
