Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab2ALBOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 20:14:14 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:49476 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab2ALBOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 20:14:12 -0500
MIME-Version: 1.0
In-Reply-To: <4F0E31D9.3080306@lge.com>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
	<1326220106-5765-10-git-send-email-tj@kernel.org>
	<20120111013212.GA6843@dhcp-172-17-108-109.mtv.corp.google.com>
	<4F0D291A.8030205@lge.com>
	<20120111170635.GE26832@google.com>
	<4F0E31D9.3080306@lge.com>
Date: Wed, 11 Jan 2012 17:14:11 -0800
X-Google-Sender-Auth: Z_Ze3wYLA6EbEzfbmypv_FzqyzQ
Message-ID: <CAOS58YOMKvb5Gj5CeP6t11NHwSdbZWUJ=uC6aRxd6CxpNrwskg@mail.gmail.com>
Subject: Re: [PATCH RESEND 9/9] block, trace: implement ioblame - IO tracer
 with origin tracking
From: Tejun Heo <tj@kernel.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@gmail.com>, axboe@kernel.dk, mingo@redhat.com,
        rostedt@goodmis.org, fweisbec@gmail.com, teravest@google.com,
        slavapestov@google.com, ctalbott@google.com, dhsharp@google.com,
        linux-kernel@vger.kernel.org, winget@google.com,
        Chanho Park <chanho61.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 11, 2012 at 5:05 PM, Namhyung Kim <namhyung.kim@lge.com> wrote:
> Yes. But that's a text-based so it might fit better to simple use cases. If
> we need further post processing based on intents, it could be better off
> having binary interface IMHO. And since we already use tracepoints anyway,
> wouldn't it be good to avoid adding another layer of interface or
> complexity?

The thing is that all entries are needed for any post processing, not
only the new ones. To use TP, either there needs to be special
"trigger the TP for all existing entries" switch somewhere or
ioblame/intents file needs to be read for existing entries. Even then,
TPs aren't guaranteed to be reliable. There's no way to detect
overflow and re-emit the event. It just isn't the right interface. The
previous version had intents_bin file in binary format but given that
there aren't too many of intents, binary interface didn't seem
necessary and ripped it out. Adding it back isn't difficult at all but
I'm not sure that's a good idea. It's not like parsing the intents
file is difficult.

Thanks.

-- 
tejun
