Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab2HFT7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 15:59:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36727 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756857Ab2HFT7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 15:59:38 -0400
Date: Mon, 6 Aug 2012 15:59:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Vasilyev <pavel@pavlinux.ru>
cc: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
        <linux-acpi@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>
Subject: Re: [linux-pm] [PATCH] ACPI: replace strlen("string") with
 sizeof("string") -1
In-Reply-To: <50201156.30704@pavlinux.ru>
Message-ID: <Pine.LNX.4.44L0.1208061556010.1649-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2012, Pavel Vasilyev wrote:

> >> http://www.gossamer-threads.com/lists/engine?do=post_attachment;postatt_id=41157;list=linux
> >
> > Interestingly, many (all?) of the changes in that patch are wrong
> > because they don't try to match the terminating '\0'.  As a result,
> > they will match against extensions of the target string as well as the
> > target string itself.
> >
> 
> strNcmp compare N bytes - http://lxr.linux.no/#linux+v3.5/lib/string.c#L270
> memcmp compare N bytes  - http://lxr.linux.no/#linux+v3.5/lib/string.c#L651

Yes.  So if s contains "abcde" then

	memcmp(s, "abc", 3) and strncmp(s, "abc", 3) will both return 0, and
	memcmp(s, "abc", 4) and strncmp(s, "abc", 4) will both return 1.

Alan Stern

