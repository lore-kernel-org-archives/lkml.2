Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab0HaGnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:43:00 -0400
Received: from www84.your-server.de ([213.133.104.84]:60126 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591Ab0HaGm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:42:58 -0400
Subject: Re: [PATCH] Add quick erase format option
From: Stefani Seibold <stefani@seibold.net>
To: dedekind1@gmail.com
Cc: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Enzinger, Robert (EXT-Other - DE/Munich)" 
	<robert.enzinger.ext@nsn.com>
In-Reply-To: <1283081435.2131.24.camel@brekeke>
References: <1281342353-18180-1-git-send-email-stefani@seibold.net>
	 <1281343038.12908.25.camel@localhost>
	 <1281343974.18398.13.camel@wall-e.seibold.net>
	 <1281353344.2332.8.camel@brekeke>
	 <1281362069.20181.16.camel@wall-e.seibold.net>
	 <1283081435.2131.24.camel@brekeke>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 31 Aug 2010 08:42:58 +0200
Message-ID: <1283236978.6083.28.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 29.08.2010, 14:30 +0300 schrieb Artem Bityutskiy:
> On Mon, 2010-08-09 at 15:54 +0200, Stefani Seibold wrote:

> > As you can see this is 296.818s vs. 7.524 or 40 times faster.
> > 
> > Maybe i do something wrong, but i have no idea. Can u explain it to me?
> 
> No, it is ok. The only thing I do not really like is the name of the
> option and the fact that you still read the beginning of PEBs and check
> for 0xFFs. And if you hit a PEB with non-0xFF, you erase it, for other
> PEBs you skip the erasure - this is error prone, because if you have one
> PEB with non-FF data, then you may have PEBs with 0xFFs at the beginning
> and garbage at the end, and you will not catch these.
> 
> I would like to change the option name so that it would reflect the
> exact use-case we are creating it for: wiped out flash. So I'd be
> happier with something like --pristine-flash.

"Pristine" is not a word which non native speaker have in its
vocabulary. Quick-format is the best, because it is exactly what it is
doing. But if you prefer this, you are okay be me.

> 
> Also, I think you should not read the beginning of the flash and check
> for 0xFFs. If the user gave us this option, he knows what he is doing
> and we can trust him, so no need to read and check, assume all PEBs are
> pristine (contain 0xFFs).
> 

The user never knows what he is doing, believe me that is what live
teach me. This is a kind of defensive programming.

> > No, we only initialize the flash, mount it as UBIFS and copy files.
> 
> OK. But did you consider to pre-create the image with ubinize and
> mkfs.ubifs tools and just flash the raw image in production? This is the
> fastest possible way.
> 

This did not work in our NSN transport environment. It would take to
much time to explain why, because the PCU software managment server is a
10 year old application which handles a wide range of transport boards
in the same way, including the old JFFS2 systems and the new UBIFS based
boards.
 
> > > So I think it is better to add an --pristine-flash option, or something
> > > like this. In this case ubiformat won't erase anything, and will assume
> > > everything is 0xFFed without reading. This should be faster and I think
> > > is better to do.
> > > 
> > 
> > This patch assumes nothing, it will skip the erase of the PEB if all
> > bytes in the EC header are 0xff. I think this is safer than your
> > suggestion.
> 
> It does assume that if the beginning of the flash contains 0xFFs then it
> is safe to treat it as erased. Instead, I think you should just trust
> the user and not even check the beginning of the flash. And this will be
> also faster.
> 

Never trust the user. And why should we remove this check? The coast is
very minimal and it will make live much easier.

For example: In our production environment everything is automated by
scripts, so the software bring up did not know if the flash is already
erased or not. It is possible that an broken used board is returned into
the production after it was repaired.

What you assume is that the user or the scripts does know the status of
the flash, but this is not true in real production environment, where
thousands of boards are prepared.

Stefani


