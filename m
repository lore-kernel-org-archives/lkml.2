Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab2HFQ2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 12:28:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36621 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752170Ab2HFQ2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 12:28:34 -0400
Date: Mon, 6 Aug 2012 12:28:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Vasilyev <pavel@pavlinux.ru>
cc: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
        <linux-acpi@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>
Subject: Re: [linux-pm] [PATCH] ACPI: replace strlen("string") with
 sizeof("string") -1
In-Reply-To: <501FEA29.1030400@pavlinux.ru>
Message-ID: <Pine.LNX.4.44L0.1208061226460.1649-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2012, Pavel Vasilyev wrote:

> 06.08.2012 18:36, Alan Stern пишет:
> > On Mon, 6 Aug 2012, Pavel Machek wrote:
> >
> >> On Thu 2012-07-26 21:39:38, Len Brown wrote:
> >>> ...both give the number of chars in the string
> >>> without the '\0', as strncmp() wants,
> >>> but sizeof() is compile-time.
> >>
> >> What about introducing something like streq() to do this
> >> automatically? This is ugly....
> >>
> >> #define streq(a, b) ... if (_buildin_constant(b)) ...
> >>
> >> ?
> >>
> >>> -	if (!strncmp(val, "enable", strlen("enable"))) {
> >>> +	if (!strncmp(val, "enable", sizeof("enable") - 1)) {
> >
> > While you're at it, there's no point using strncmp when you know the
> > length of one of the strings beforehand.  Just use memcmp, and don't
> > subtract 1 from the sizeof value.
> 
> http://www.gossamer-threads.com/lists/engine?do=post_attachment;postatt_id=41157;list=linux

Interestingly, many (all?) of the changes in that patch are wrong 
because they don't try to match the terminating '\0'.  As a result, 
they will match against extensions of the target string as well as the 
target string itself.

Alan Stern

