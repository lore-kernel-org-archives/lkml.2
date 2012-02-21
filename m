Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab2BUVGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 16:06:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab2BUVGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 16:06:04 -0500
Date: Tue, 21 Feb 2012 13:06:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: dave@gnu.org
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Matthew Wilcox <matthew@wil.cx>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] locks: new procfs lockinfo
Message-Id: <20120221130601.eb15b1a4.akpm@linux-foundation.org>
In-Reply-To: <1329737454.3058.3.camel@offbook>
References: <1329737454.3058.3.camel@offbook>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Feb 2012 12:30:54 +0100
Davidlohr Bueso <dave@gnu.org> wrote:

> From: Davidlohr Bueso <dave@gnu.org>
> 
> Based on our previous discussion https://lkml.org/lkml/2012/2/10/462 we came to
> agree on deprecating the current /proc/locks in favor of a more extensible interface.
> The new /proc/lockinfo file exports similar information - except instead of maj:min the
> device name is shown - and entries are formated like those in /proc/cpuinfo, allowing us
> to add new entries without breaking userspace.

Looks pretty good to me.  A few things..

The above text doesn't really explain why we're adding the new procfs
file.  What's wrong with the current format and why do we need a new
file?  The basic rationale for changing the kernel is the most
important part of the whole patch, and it's missing!

Also, there's no description here of the new format.  Ideally it will
be documented, perhaps in Documentation/filesystems/proc.txt.  If not
that then it should at least be *fully* described in the changelog,
along with examples.  Because if we can't clearly see the proposed
format, how can we review the patch?


I'd also like to see some discussion of the namespace side of things. 
How do namespaces play with locks?  Mainly pid namespaces, I guess.  Is
it possible to look at the output and determine which namespace a lock
belongs to?  Does that even make sense?  I don't know what our
long-term plan is for namespaces-versus-locks, but whatever it is, this
new interface should be designed to work well with it.

