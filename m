Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2LXGNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 01:13:34 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:56599 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab2LXGNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 01:13:32 -0500
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Dec 2012 01:13:32 EST
MIME-Version: 1.0
In-Reply-To: <20121221154457.GE15204@liondog.tnic>
References: <1356078018-31905-1-git-send-email-namhyung@kernel.org>
 <1356078018-31905-7-git-send-email-namhyung@kernel.org> <20121221083205.GA15226@liondog.tnic>
 <878v8repdt.fsf@sejong.aot.lge.com> <20121221154457.GE15204@liondog.tnic>
From: Namhyung Kim <namhyung@kernel.org>
Date: Mon, 24 Dec 2012 15:04:59 +0900
X-Google-Sender-Auth: KL9mSmBWaJKmp5zrkwDCVW_h54c
Message-ID: <CAM9d7cj2mtQ5=vzLeAREA4kUYKh_qJYi+c2AVry6eK1H58f+zA@mail.gmail.com>
Subject: Re: [PATCH 6/6] perf annotate: Add --gtk option
To: Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2012 at 12:44 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Dec 21, 2012 at 06:16:46PM +0900, Namhyung Kim wrote:
>> Current setup_browser() code checks the stdin to be a tty and if
>> not it assumes piping to other commands so set the use_browser to 0
>> (stdio) and disables GTK output.
>>
>> Maybe we can change this behavior for --gtk case.
>
> Change it in the sense that for the --gtk case stdin doesn't have to
> be a tty? So that with --gtk you can still pipe perf output to other
> commands?
>
> I can't imagine a sensible --gtk use case with output piped to other
> commands. Hmm.

Right.  I also have no idea what's the best way to handle --gtk option
with the piped output.  I can think of 3 options for this:

1) exit with a error message
2) honor --gtk option and launch a gui browser
3) honor piped output and print to stdout (thus ignore --gtk) like
this patch does

Any thoughts?

-- 
Thanks,
Namhyung
