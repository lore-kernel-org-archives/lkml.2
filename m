Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab0JDLIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 07:08:34 -0400
Received: from mail001.aei.ca ([206.123.6.130]:59540 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab0JDLId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 07:08:33 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Nitin Gupta <ngupta@vflare.org>
Subject: Re: OOM panics with zram
Date: Mon, 4 Oct 2010 07:08:27 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-crc+; KDE/4.5.1; x86_64; ; )
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        "linux-mm" <linux-mm@kvack.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Greg KH - Meetings" <ghartman@us.ibm.com>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org> <1286134073.9970.11.camel@nimitz> <4CA8DC47.5070003@vflare.org>
In-Reply-To: <4CA8DC47.5070003@vflare.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010040708.27939.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 October 2010 15:40:55 Nitin Gupta wrote:
> On 10/3/2010 3:27 PM, Dave Hansen wrote:
> > On Sun, 2010-10-03 at 14:41 -0400, Nitin Gupta wrote:
> >> Ability to write out zram (compressed) memory to a backing disk seems
> >> really useful. However considering lkml reviews, I had to drop this
> >> feature. Anyways, I guess I will try to push this feature again.
> > 
> > I'd argue that zram is pretty useless without some ability to write to a
> > backing store, unless you *really* know what is going to be stored in it
> > and you trust the user.  Otherwise, it's just too easy to OOM the
> > system.
> >
> > I've been investigating backing the xvmalloc space with a tmpfs file.
> > Instead of keeping page/offset pairs, you just keep a linear address
> > inside the tmpfile file.  There's an extra step needed to look up and
> > lock the page cache page into place each time you go into the xvmalloc
> > store, but it does seem to basically work.  The patches are really rough
> > and not quite functional, but I'm happy to share if you want to see them
> > now.
> >
> 
> Yes, I would be really interested to look at them. Thanks.
> 
>  
> >> Also, please do not use linux-next/mainline version of compcache. Instead
> >> just use version in the project repository here:
> >> hg clone https://compcache.googlecode.com/hg/ compcache 
> >>
> >> This is updated much more frequently and has many more bug fixes over
> >> the mainline. It will also be easier to fix bugs/add features much more
> >> quickly in this repo rather than sending them to lkml which can take
> >> long time.
> > 
> > That looks like just a clone of the code needed to build the module.  
> > 
> > Kernel developers are pretty used to _some_ kernel tree being the
> > authoritative source.  Also, having it in a kernel tree makes it
> > possible to get testing in places like linux-next, and it makes it
> > easier for people to make patches or kernel trees on top of your work. 
> > 
> > There's not really a point to the code being in -staging if it isn't
> > somewhat up-to-date or people can't generate patches to it.  It sounds
> > to me like we need to take it out of -staging.
> > 
> 
> I will try sending patches to sync mainline and hg code (along with
> some changes in pipeline), or maybe just take it out of -staging and
> send fresh patch series.

Or move it to a git tree.  Then generating patches becomes tivial for all of
us and keeping staging upto date becomes easier for you.

Ed

> Thanks,
> Nitin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
