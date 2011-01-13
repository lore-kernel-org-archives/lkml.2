Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab1AMOaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 09:30:55 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40464 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab1AMOax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 09:30:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=eokRrnhu+MSYFIm37DT6W43jGx6ioW/lPRDHoh6txUUaIRlBm+zXyQYOtpFPstLRzh
         MaLILLD9rk+rBlnKdwfsEa3xiEL8RAsCz1cL5+FmxA0MLccDEHt+1Tf07FlIxXMnXC3E
         heFpti1Tyo+/jnOL93vNwSMqrw+kNxIHRwmI0=
MIME-Version: 1.0
In-Reply-To: <4D2F0B6A.6010201@redhat.com>
References: <16069.1294853673@localhost>
	<4D2E4611.90002@redhat.com>
	<4D2E6129.8000700@ce.jp.nec.com>
	<20110113110640.GC30719@htj.dyndns.org>
	<4D2EE156.1050006@redhat.com>
	<20110113122701.GG16523@nb.net.home>
	<20110113131216.GF30719@htj.dyndns.org>
	<20110113132637.GH16523@nb.net.home>
	<20110113133722.GG30719@htj.dyndns.org>
	<4D2F04FF.1070309@redhat.com>
	<20110113141107.GI30719@htj.dyndns.org>
	<4D2F0B6A.6010201@redhat.com>
Date: Thu, 13 Jan 2011 15:30:52 +0100
X-Google-Sender-Auth: CexP-cbqcTdLIC-yRcvp5VD-seQ
Message-ID: <AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()
From: Tejun Heo <tj@kernel.org>
To: Milan Broz <mbroz@redhat.com>
Cc: Karel Zak <kzak@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 13, 2011 at 3:25 PM, Milan Broz <mbroz@redhat.com> wrote:
> Maybe, but this was not invented in DM/MD camp:-)
> Probably Kay or Greg can answer why it was done this way?

Let's not play the dig the history and blame game if possible.  We
(including me, of course) all did a lot of horrible things in the
past.  :-)

> For DM it just added links to be proper user of it, see
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=f165921df46a977e3561f1bd9f13a348441486d1
>
> Anyway, it is /sys/block - so it represents block devices.
>
> If btrfs internally creates some virtual _block_ device for its pool, it should
> present it here too with slaves/holders. If not, why it should create any links there?

Yeah, that's the most bothering part for me.  The biggest customers of
bd_claim are filesystems and all these custom symlinkeries don't do
nothing for them.  It just doesn't make a whole lot of sense to me.

Thanks.

-- 
tejun
