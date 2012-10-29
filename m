Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab2J2Inl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 04:43:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46607 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757817Ab2J2Inj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 04:43:39 -0400
Date: Mon, 29 Oct 2012 09:43:34 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
In-Reply-To: <8d5c617feaaecfcf9e358a8b2cc35d20@hardeman.nu>
Message-ID: <alpine.LNX.2.00.1210290942150.19184@pobox.suse.cz>
References: <20121029111403.911c815a3c7d8d9572ff8e89@canb.auug.org.au> <8d5c617feaaecfcf9e358a8b2cc35d20@hardeman.nu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2012, David Härdeman wrote:

> > allmodconfig) failed like this:
> > 
> > drivers/hid/hid-picolcd_cir.c: In function 'picolcd_init_cir':
> > drivers/hid/hid-picolcd_cir.c:119:27: error: 'RC_TYPE_ALL' undeclared
> > (first use in this function)
> 
> I can fix it, should be easy (rename RC_TYPE_ALL to RC_BIT_ALL).
> 
> > Caused by commit c003ab1bedf0 ("[media] rc-core: add separate defines
> for
> > protocol bitmaps and numbers").  The new reference was introduced in
> > commit ae08e324146c ("HID: picoLCD: Add support for CIR") which was
> > merged by Linus on October 2 into v3.7-rc1 via the hid tree.
> > 
> > I have used the v4l-dvb tree from next-20121026 for today.
> 
> The question is in which form you want the patch - as a separate patch or
> a new version of commit c003ab1bedf0 (i.e. the entire patch)? Also, against
> which tree should I create the patch?

I am not able to see c003ab1bedf0 in repo at

	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git

so I am not entirely sure what's happening, but I guess that you have just 
changed the define for RC_TYPE_ALL and updated all the drivers under 
drivers/media to use the new name. So please do so for 
drivers/hid/hid-picolcd_cir.c the same way.

Thanks,

-- 
Jiri Kosina
SUSE Labs
