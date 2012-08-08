Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab2HHB1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 21:27:23 -0400
Received: from netrider.rowland.org ([192.131.102.5]:43755 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754824Ab2HHB1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 21:27:21 -0400
Date: Tue, 7 Aug 2012 21:27:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pavel Vasilyev <pavel@pavlinux.ru>
cc: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
        <linux-acpi@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>
Subject: Re: [linux-pm] [PATCH] ACPI: replace strlen("string") with
 sizeof("string") -1
In-Reply-To: <5021A372.8030409@pavlinux.ru>
Message-ID: <Pine.LNX.4.44L0.1208072124250.8098-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2012, Pavel Vasilyev wrote:

> >>> Yes.  So if s contains "abcde" then
> >>>
> >>> 	memcmp(s, "abc", 3) and strncmp(s, "abc", 3) will both return 0, and
> >>> 	memcmp(s, "abc", 4) and strncmp(s, "abc", 4) will both return 1.
> >>
> >> No matter what is contained in *s, "abcde" or "abcxxx",
> >> are important first N bytes. The second example, you see,
> >> a little bit stupid, and devoid of logic. :)
> >
> > Maybe yes, maybe no.  It all depends on what you want.
> >
> > For example, if you're looking for "on" or "off", what should you do
> > when the user writes "onoff"?  You could accept it as meaning the same
> > as "on", but if you were being careful then you would want to reject it
> > as a meaningless value.
> 
> 
> The users should't be allowed to think!
> There is "on" - the size of 2 bytes, or "off" - 3 bytes,
> other variations - user error.
> 
> We do not create a kernel with artificial intelligence? ;)

Let me rephrase the previous statement, as it appears you did not 
understand what I meant.

If the kernel is testing for "on" or "off", what should it do when the
user writes "onoff"?  The kernel could accept this as meaning the same
as "on", but if the kernel was being careful then it should reject
"onoff" as a meaningless value.  A 2-byte comparison for "on" would
accept "onoff" whereas a 3-byte comparison would not.

Alan Stern

