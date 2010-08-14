Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab0HNEiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 00:38:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62293 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562Ab0HNEiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 00:38:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=baP02DHbfefg5BInKVO47VZBlAXbqsMCaY+Br0aM1bVFxG4YrOui1f47f2nQGWTyP+
         YtV686Jek4zKC/0K4Ohaq2hQVLA4x54WnDeuc0oh0pue0auW/jeDuk/2GfW8WxmjQLv8
         QBnL1qYDabxJHj3IgdMMzqCmbSvbZDYDm/KYE=
Subject: Re: [PATCH] perf trace: get rid of the hard-coded paths in the
 report scripts
From: Tom Zanussi <tzanussi@gmail.com>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, acme@infradead.org, mingo@elte.hu,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org
In-Reply-To: <4c65046e.cae9d80a.0d93.4def@mx.google.com>
References: <1281635958-21177-1-git-send-email-tzanussi@gmail.com>
	 <4c65046e.cae9d80a.0d93.4def@mx.google.com>
Content-Type: text/plain
Date: Fri, 13 Aug 2010 23:38:06 -0500
Message-Id: <1281760686.6598.53.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

On Fri, 2010-08-13 at 10:30 +0200, Stephane Eranian wrote:
> Tom,
> 
> Here is version that works for me. Besides the stat() to access() change, I fixed
> the pathname you were building, it was missing the language name. The way I solved
> that is by leveraging the scripting_ops->name field, but for that I had to make sure
> it would match the subdir name, i.e., all lower-case. I also add an error message
> when the script is not found, so users understand what went wrong without turning
> on any sort of debugging.
> 

Hmm, I'm not sure why the previous version didn't work for you, since
that version changed all the scripts to the form:

python/sctop.py

which applied to the format string there, "%s/scripts/%s"

gives

..../scripts/python/sctop.py

so it should have worked.

With your version, I get:

root@tropicana:~# perf trace sctop
script python/sctop.py not found

because the script names still have the form python/sctop.py but are
applied to the new format string "%s/scripts/%s/%s" which gives:

..../scripts/python/python/sctop.py

After removing the python/ prefix from all the scripts, everything works
fine:

root@tropicana:~# perf trace sctop
good output...

root@tropicana:~# perf record -c 1 -e raw_syscalls:sys_enter -a -- sleep
1
[ perf record: Woken up 0 times to write data ]
[ perf record: Captured and wrote 22.546 MB perf.data (~985061
samples) ]
root@tropicana:~# perf trace -g python
generated Python script: perf-trace.py
root@tropicana:~# perf trace -s perf-trace.py > out
good output...

Anyway, for all the reasons you stated and the fact that it gets rid of
everything but the bare script name, I think your version is a nice
improvement - I'll repost it along with the small script changes
mentioned shortly.

Tom


