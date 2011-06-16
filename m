Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752Ab1FPVZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 17:25:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53814 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758238Ab1FPVZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 17:25:50 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 16 Jun 2011 23:25:26 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: dgilbert@interlog.com
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcm@redhat.com, hare@suse.de, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device
 structure
Message-ID: <20110616232526.68820a6f@stein>
In-Reply-To: <4DFA44D4.2010602@interlog.com>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
	<20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp>
	<20110615153337.GA10160@kroah.com>
	<4DF9F11F.705@hitachi.com>
	<20110616154129.GA31498@kroah.com>
	<1308239454.2436.34.camel@mulgrave>
	<20110616161442.GA32113@kroah.com>
	<1308241506.2436.44.camel@mulgrave>
	<BANLkTi=qHhzwGfp4v8B1CAmT+gtA=sOgvw@mail.gmail.com>
	<BANLkTikUNqTxgD_+TTVpcFyRDu_fSesrsg@mail.gmail.com>
	<4DFA44D4.2010602@interlog.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 16 Douglas Gilbert wrote:
> One obvious candidate for a preferred block device name
> is:
>    - a SATA disk's WWN (NAA 5 64 bit), or
>    - a SCSI disk's logical unit name (e.g. SAS: NAA 5)
> 
> These names (actually numbers) are meant to be world wide
> unique.
> 
> The kernel's device naming (following from how devices are
> discovered) is topological.

I disagree.

1. The kernel name is not about topology.  It is from a flat
   namespace where nothing else than oder of registration counts.
   In some very simple systems there is a deceptively strong correlation
   between topology and order of registration.  But in the general case
   there is no correlation.

2. The persistent worldwide unique name of a device may actually not be
   what a particular admin considers a "preferred" name.  They may prefer
   a topological name ("disk in bay 7") or they may prefer a mnemonic name
   from a label on the hardware, invented and tacked on by the vendor
   (especially vendor--model name tuples like "Canon MV5i camcorder") or by
   the admin themselves, or stored in device memory rather than written
   out on a sticker.

Besides, the preference may change from situation to situation.  In some
situations, _two_ names are actually required at the same time (besides the
unloved kernel name).  So, a "preferred name" as a single datum per device
does not cut it, as also already noted by Kay at the example of the netif
alias.

The retrieval and mapping of the list of "more or less preferred names"
that people realistically use is probably better implemented in userland.
Any kernel solution is bound to impose arbitrary limitations.
-- 
Stefan Richter
-=====-==-== -==- =----
http://arcgraph.de/sr/
