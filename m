Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab1LVBut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:50:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab1LVBuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:50:46 -0500
Date: Wed, 21 Dec 2011 17:49:55 -0800
From: Greg KH <gregkh@suse.de>
To: NeilBrown <neilb@suse.de>
Cc: Tim Bird <tim.bird@am.sony.com>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: RFC: android logger feedback request
Message-ID: <20111222014955.GB13085@suse.de>
References: <4EF264C3.6000104@am.sony.com>
 <20111221231956.GB23859@suse.de>
 <4EF27B85.9080801@am.sony.com>
 <20111222122026.3a0fae36@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222122026.3a0fae36@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 12:20:26PM +1100, NeilBrown wrote:
> On Wed, 21 Dec 2011 16:36:21 -0800 Tim Bird <tim.bird@am.sony.com> wrote:
> 
> > On 12/21/2011 03:19 PM, Greg KH wrote:
> > > That all describes the current code, but you haven't described what's
> > > wrong with the existing syslog interface that requires this new driver
> > > to be written.  And why can't the existing interface be fixed to address
> > > these (potential) shortcomings?
> > 
> > 
> > >> One specific question I have is where is the most appropriate
> > >> place for this code to live, in the kernel source tree?
> > >> Other embedded systems might want to use this system (it
> > >> is simpler than syslog, and superior in some ways), so I don't
> > >> think it should remain in an android-specific directory.
> > > 
> > > What way is it superior?
> > 
> > Here are some ways that this code is superior to syslog:
> 
> It is certainly nice and simple.  It really looks more like a filesystem than
> a char device though...  though they aren't really files so much as lossy
> pipes.  I don't think that's a problem though, lots of things in filesystems
> don't behave exactly like files.
> 
> If you created a 'logbuf' filesystem that used libfs to provide a single
> directory in which privileged processes could create files then you wouldn't
> need the kernel to "know" the allowed logs: radio, events, main, system.
> The size could be set by ftruncate() (by privileged used again) rather than
> being hardcoded.
> 
> You would defined 'read' and 'write' much like you currently do to create a list of
> datagrams in a circular buffer and replace the ioctls by more standard
> interfaces:
> 
> LOGGER_GET_LOG_BUG_SIZE would use 'stat' and the st_blocks field
> LOGGER_GET_LOG_LEN would use 'stat' and the st_size field
> LOGGER_GET_NEXT_ENTRY_LEN could use the FIONREAD ioctl
> LOGGER_FLUSH_LOG could use ftruncate
> 
> The result would be much the same amount of code, but an interface which has
> fewer details hard-coded and is generally more versatile and accessible.

But, almost all of this is already in the syslog system call today,
right?  So why create a new user api for something we have?

greg k-h
