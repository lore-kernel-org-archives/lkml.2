Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101Ab2HJDOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 23:14:06 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64942 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab2HJDOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 23:14:04 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-52-50247c799bda
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 1/7] perf hists: Separate out hist print functions
References: <1344243462-28403-1-git-send-email-namhyung@kernel.org>
	<1344243462-28403-2-git-send-email-namhyung@kernel.org>
	<20120809191827.GE4084@infradead.org>
Date: Fri, 10 Aug 2012 12:08:13 +0900
In-Reply-To: <20120809191827.GE4084@infradead.org> (Arnaldo Carvalho de Melo's
	message of "Thu, 9 Aug 2012 16:18:27 -0300")
Message-ID: <87fw7vwijm.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Arnaldo

On Thu, 9 Aug 2012 16:18:27 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Aug 06, 2012 at 05:57:36PM +0900, Namhyung Kim escreveu:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Separate out those functions into ui/hist.c. This is required for
>> upcoming changes.
>
> Isn't it better to further separate it by introducing the ui/stdio/
> directory since these functions use fprintf?
>
Maybe. I agree that general ui code reside on ui/ and front-end
specifics should go to their subdirectories. But not sure for the stdio
case since they'll have very simple code only.

For this case, most of functions would be converted to manipulate a
string buffer like scnprintf and shared by all front-end's as long as
possible - callchain print code needs some more working. But if you
want, I'll separate out actual fprintf's to ui/stdio/.

Thanks,
Namhyung

