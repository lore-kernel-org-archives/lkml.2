Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab0HRAXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 20:23:42 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34367 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab0HRAXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 20:23:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=FFPIfrpCsgKJPpfI6B7EvuRs54ZhfzqRolfpe3gorm2Xyl9mUkIdRoJwkuNsEtwIUf
         NTNV6wVaGZhLTLEXddpSzqzjLd5vKnBnyQDYZIuVZ2iCSE2wtNKV5T/iCCzU8eT8Tm9F
         hqjJy+Xgg18XgwCKVQUXDyW2UAY1FTyMl7g2Q=
MIME-Version: 1.0
In-Reply-To: <20100818085333.02fa54d4@notabene>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com>
	<1281282776-5447-15-git-send-email-vaurora@redhat.com>
	<20100810085641.2b9a714c@notabene>
	<20100817204430.GE5556@shell>
	<20100818085333.02fa54d4@notabene>
Date: Wed, 18 Aug 2010 02:15:20 +0200
X-Google-Sender-Auth: ZRkj5sFD2q-5YVVJnNdV_edsEU0
Message-ID: <AANLkTinL0cLpV=ZUZpej2AKUC83sW4Bd-Gi2YsVFFi0O@mail.gmail.com>
Subject: Re: [PATCH 14/39] union-mount: Union mounts documentation
From: Luca Barbieri <luca@luca-barbieri.com>
To: Neil Brown <neilb@suse.de>
Cc: Valerie Aurora <vaurora@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I personally like the block layer solution better and would be
>> happiest if all unionfs and aufs users switched to it and no one
>> needed union mounts. :)

I think that the safety of personal data and the ability to make
changes to the layers independently are very important features that
justify union mounts.

If you do block-level COW and then lose the lower filesystem layer
(e.g. lose the LiveCD or lose network access to the NFS master), then
you have no guarantee of being able to access the data you added (e.g.
your /home) since you'll only have a corrupted "filesystem piece" that
fsck may or may not be able to fix.

Also, you can't modify the lower layer at all (without rebuilding the
upper layer from scratch), while with an union mount minor changes can
be done with no issues (e.g. replacing the LiveCD with a new minor
update, or applying a security update to the NFS master), and major
ones can be done with some care.

Hence, in any case where the layers are even slightly separated, or
where you need to modify them independently, or extract the changes,
union mounts/unionfs are much better, and often actually the only
viable solution.

This includes the LiveCD case, the NFS mount case and some use cases
with virtual machines.

This would be the case even more strongly if additional features like
online modification of lower layers, or path resolution to the most
recent file instead of the one in the highest layer, were added.

Of course, this is why people currently use unionfs or aufs, and a
VFS-based solution seems just better, since it is going to be more
efficient and guaranteed to be relatively bug-free once it satisfies
the high quality requirements for inclusion in the core kernel.
