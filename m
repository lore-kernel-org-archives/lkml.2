Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab2DHBCq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 21:02:46 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56251 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752232Ab2DHBCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 21:02:45 -0400
Message-ID: <1333846964.1834.33.camel@joe2Laptop>
Subject: Re: [PATCH] printk: support structured and multi-facility log
 messages
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
Date: Sat, 07 Apr 2012 18:02:44 -0700
In-Reply-To: <1333737301.29217.11.camel@mop>
References: <1333569554.864.3.camel@mop>
	 <CA+55aFyMO=xx0xNvggR-1fs-jKi_zaayNfgCa3HCNkvH0yA16g@mail.gmail.com>
	 <1333655231.725.27.camel@mop> <1333674768.23520.123.camel@joe2Laptop>
	 <CA+55aFyE41U9OPr7mrAA2ZJKuQ2jvH-KmusUNyfYbH8tOm6yiQ@mail.gmail.com>
	 <1333737301.29217.11.camel@mop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(grumble, evolution is a stupid email client, resending)

On Fri, 2012-04-06 at 20:35 +0200, Kay Sievers wrote:
> On Thu, 2012-04-05 at 18:31 -0700, Linus Torvalds wrote:
> > On Thu, Apr 5, 2012 at 6:12 PM, Joe Perches <joe@perches.com> wrote:
> > >
> > > I still think this should be 3 patches not 1.
> > 
> > I do agree that that would be lovely. That patch is really hard to
> > read, and it would be helpful if some of it was split up a bit. For
> > example, separating out the "move log buffer to be packetized"
> > (without actually doing the new things) from for the "introduce new
> > interfaces" would be quite nice.
> > 
> > In fact, I think I could merge something that does the packetization
> > early, if it is fairly obvious that it doesn't do anything else. Just
> > making the dmesg ASCII timestamp be something that is a "read buffer"
> > time thing rather than "generate printk" time thing would be nice, and
> > I think the sequence numbers can be useful even with all the old
> > interfaces.
> > 
> > So if somebody wants to help with things like that, and try to turn
> > this into a more gradual thing, I think we could merge at least some
> > initial parts of this patch even for 3.4.
> 
> Here is only the conversion of the byte- to the record-buffer split out
> of the big patch.
> 
> Unfortunately, it's still pretty big, and the patch not easy to read;
> the code itself looks better than the patch. At this moment I have no
> convincing idea how to split that into more pieces.

I'll spend some time on breaking up Kay's
patch in the next couple of weeks.

I'll try to get my printk restructuring patch
out by Monday.

I think Kay's still relatively large patch can
be broken into a smaller sequence of:

1.  Make log_buf ascii "record" oriented
2.  Add struct for timestamp/sequence and
    integrate it into log_buf with syslog_print
3.  Add printk_emit and key/value support
    into log_buf

After that, I'll try adding lzo compression to
the message bits and see if that is any benefit.

After Monday, I'll be effectively unavailable
for a few weeks though.

