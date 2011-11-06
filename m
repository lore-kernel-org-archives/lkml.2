Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1KFU0u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 15:26:50 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52265 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab1KFU0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 15:26:48 -0500
Subject: Re: virtio-pci new configuration proposal
From: Sasha Levin <levinsasha928@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Anthony Liguori <anthony@codemonkey.ws>
In-Reply-To: <20111106073007.GA7146@redhat.com>
References: <1320259767.22582.2.camel@lappy>
	 <8762j2t19l.fsf@rustcorp.com.au> <1320309203.29407.1.camel@lappy>
	 <87lirwrzlg.fsf@rustcorp.com.au> <20111104114033.GA21308@redhat.com>
	 <1320409939.3334.6.camel@lappy> <20111104135113.GA24452@redhat.com>
	 <1320414804.3334.13.camel@lappy> <20111104142338.GB24452@redhat.com>
	 <1320418385.3334.25.camel@lappy>  <20111106073007.GA7146@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Sun, 06 Nov 2011 22:24:57 +0200
Message-ID: <1320611097.3299.10.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-06 at 09:30 +0200, Michael S. Tsirkin wrote:
> On Fri, Nov 04, 2011 at 04:53:05PM +0200, Sasha Levin wrote:
> > > > > > As you said, the PCI cap list was introduced both to save space (which
> > > > > > is not the motivation here), and because it's a very efficient
> > > > > 
> > > > > It's actually pretty inefficient - there's an overhead of 3 bytes for
> > > > > each vendor specific option.
> > > > 
> > > > It's efficient because while you pay a small price for each optional
> > > > option it also means that that option is optional and won't clutter the
> > > > config space if it's not really in use.
> > > 
> > > I guess my assumption is that most options will be in use,
> > > not discarded dead-ends.
> > 
> > I don't know about that. 64 bit features would be pretty rare for now -
> > and I don't think that setting the alignment will be also enabled by
> > default.
> 
> Setting the alignment might not be *used* by default but
> I think it must be enabled by default to allow bios access.
> 
> > I think that we're looking at it differently because I assume that any
> > feature we add at this point would be optional and used only in specific
> > scenarios, while you think that everything added will be used most of
> > the time.
> 
> Options must often be present even if not used. For example, as device
> has no way to know whether a guest will want to program alignment, it
> has to make that option available.

They should be enabled, but heres the difference between the two
approaches is that if it's cap it simply won't be there, while in the
other case it would just remain empty at some random offset of the
struct.

-- 

Sasha.

