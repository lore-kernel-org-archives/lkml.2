Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab2G3Rdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:33:39 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:38307 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab2G3Rdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:33:35 -0400
MIME-Version: 1.0
In-Reply-To: <1343649500-18491-3-git-send-email-anton.vorontsov@linaro.org>
References: <20120730115719.GA5742@lizard>
	<1343649500-18491-3-git-send-email-anton.vorontsov@linaro.org>
Date: Mon, 30 Jul 2012 10:33:34 -0700
X-Google-Sender-Auth: 83bo_JEkHeBlq8cBhGZkfsMVecQ
Message-ID: <CAMbhsRS1cOf1T8k7K6CFmRA7M52AGPZ2TqmEnpZqDGYnbyetbw@mail.gmail.com>
Subject: Re: [PATCH 03/11] kdb: Implement disable_nmi command
From: Colin Cross <ccross@android.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 4:58 AM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> This command disables NMI-entry. If NMI source was previously shared with
> a serial console ("debug port"), this effectively releases the port from
> KDB exclusive use, and makes the console available for normal use.
>
> Of course, NMI can be reenabled, enable_nmi modparam is used for that:
>
>         echo 1 > /sys/module/kdb/parameters/enable_nmi

This is very different behavior from the FIQ debugger "console"
command you are trying to replace.  In the FIQ debugger, everything
goes through the FIQ/NMI, even when in console mode.  That means that
the user can always get back to FIQ debugger/KDB mode using a special
sequence (we use a break character).  With your implementation, if you
switch from KDB to console to see if the console is working, and find
that it is not working, you can never get back into KDB.
