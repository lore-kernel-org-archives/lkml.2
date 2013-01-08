Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab3AHWNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 17:13:17 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35303 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753662Ab3AHWNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:13:16 -0500
X-Sasl-enc: BW8J/qhTeLr+ZDuTKvq3QQESK7LVznpG3eQPKTEj8TtM 1357683195
Date: Tue, 8 Jan 2013 14:13:14 -0800
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] staging: zram: fix invalid memory references
 during disk write
Message-ID: <20130108221314.GA29852@kroah.com>
References: <1357145621-3438-1-git-send-email-ngupta@vflare.org>
 <CAPkvG_fGpjcVqeYgZnzNM6dpicB5YaJP9TA9bz2nUDJrHtJkGw@mail.gmail.com>
 <CAPkvG_eY8Fucft_Up9HgxWbpr2YG8vCQ_Pwi3QMfxcgDkgQ+Tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPkvG_eY8Fucft_Up9HgxWbpr2YG8vCQ_Pwi3QMfxcgDkgQ+Tg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 02:00:27PM -0800, Nitin Gupta wrote:
> On Fri, Jan 4, 2013 at 12:25 PM, Nitin Gupta <ngupta@vflare.org> wrote:
> > On Wed, Jan 2, 2013 at 8:53 AM, Nitin Gupta <ngupta@vflare.org> wrote:
> >> Fixes a bug introduced by commit c8f2f0db1 ("zram: Fix handling
> >> of incompressible pages") which caused invalid memory references
> >> during disk write. Invalid references could occur in two cases:
> >>  - Incoming data expands on compression: In this case, reference was
> >> made to kunmap()'ed bio page.
> >>  - Partial (non PAGE_SIZE) write with incompressible data: In this
> >> case, reference was made to a kfree()'ed buffer.
> >>
> >> Fixes bug 50081:
> >> https://bugzilla.kernel.org/show_bug.cgi?id=50081
> >>
> >
> > Greg: can you please add this to staging? It fixes an important issue
> > and is tested by many users.
> >
> 
> 
> It's still not in staging. Any reason why you want to accept this patch?

Because I'm still catching up after being on vacation for 3 weeks?  I
only got back yesterday and have a few thousand emails/patches to make
it through.  Patches for staging drivers are way down on the list of
priorities for me, especially the zram/zcache/zwhatever mess that we
currently have...

Don't worry, it's not lost, and will make it in soon, please give me a
chance.

greg k-h
