Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab2EGHlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 03:41:49 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52207 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab2EGHls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 03:41:48 -0400
X-AuditID: 9c93016f-b7c79ae0000006b3-99-4fa77cb5b1c6
From: Namhyung Kim <namhyung.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] perf ui/gtk: Use struct perf_error_ops
References: <1336370582-30959-1-git-send-email-namhyung.kim@lge.com>
	<1336370582-30959-2-git-send-email-namhyung.kim@lge.com>
	<CAOJsxLEo32u8iYvQ+qeBX2YSKq=ftHs2jMdsKcCWWKO07XPGHg@mail.gmail.com>
Date: Mon, 07 May 2012 16:40:19 +0900
In-Reply-To: <CAOJsxLEo32u8iYvQ+qeBX2YSKq=ftHs2jMdsKcCWWKO07XPGHg@mail.gmail.com>
	(Pekka Enberg's message of "Mon, 7 May 2012 10:17:41 +0300")
Message-ID: <874nrssal8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 7 May 2012 10:17:41 +0300, Pekka Enberg wrote:
> On Mon, May 7, 2012 at 9:03 AM, Namhyung Kim <namhyung.kim@lge.com> wrote:
>> Define and use perf_gtk_eops to provide a GTK2 message
>> dialog for error reporting. To do that, we need global
>> main_window variable for tracking UI state.
>>
>> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
>
> I still don't like the dialog-based approach because it requires the
> *user* to respond. Just add a label to the GTK window and show the
> latest message there. If you want to make it even prettier, make the
> label clickable and open up a popup that shows all the warnings and
> errors in a separate window...

As I said before, most of calls to ui__warning/error are called just
before the main window is closed or critical enough to require user's
reponse - if not, it probably needs to use other API.

So I think it's OK for the current symantics of the API.

Thanks,
Namhyung
