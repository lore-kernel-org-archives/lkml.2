Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab1EYUmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:42:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42128 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab1EYUmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:42:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=bBnM2VEo3isMsaoLW3uXa7xv9TTI1w3ghuhtG2pPedeOQVLqYPhKD3lzBQZjvfC8Cp
         gELH4aFumxrn5pb6eBox7dPtIBAoVycu4AN6A/TBoBDkrQrafo2nOLtgwigmlLTRJjiS
         Gkxvp3Xgs//aWi3sXrx/5UEYNV8n4m8eFFxtw=
Date: Wed, 25 May 2011 16:42:15 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@ubuntu-natty
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Parag Warudkar <parag.lkml@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re:
 __elv_add_request OOPS]
In-Reply-To: <BANLkTimndXcBJ9wwJrcTt3Pf3vaNVUUtwg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1105251638220.8972@ubuntu-natty>
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar> <4DDB8BF6.2000304@fusionio.com> <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty> <4DDCB1C8.7040708@fusionio.com> <alpine.DEB.2.02.1105251416340.3472@ubuntu-natty> <BANLkTimZi6rPSA-1OX+ZAh3135SMpDcHKg@mail.gmail.com>
 <4DDD5240.2060308@fusionio.com> <BANLkTikSXMZ3a6-e4-k5dV5vHtegxuUL-w@mail.gmail.com> <4DDD55D6.1080909@fusionio.com> <alpine.DEB.2.02.1105251548420.2742@ubuntu-natty> <BANLkTimWPWc4k2_q0KZpmWo9G93UmVWoxA@mail.gmail.com> <alpine.DEB.2.02.1105251613500.8972@ubuntu-natty>
 <BANLkTimndXcBJ9wwJrcTt3Pf3vaNVUUtwg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1854863386-1306356137=:8972"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1854863386-1306356137=:8972
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT



On Wed, 25 May 2011, Linus Torvalds wrote:

> On Wed, May 25, 2011 at 1:18 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
> >        SDEV_OFFLINE,           /* Device offlined (by error handling or
> >                                 * user request */
> 
> So how do you fix the error or online it again? No chance it should
> have commands passed to it to do that?

Yeah - that makes sense. By that logic, looks like we can only disallow 
for SDEV_DEL (if we decide to do that check here).

> I don't know. My point is that I don't see why we should look at the
> state at this point at all. We do that _later_.

If we can do it later, well and good. I just didn't think it would hurt to 
check upfront in ioctl if we are dealing with a dead device.

Parag
--8323329-1854863386-1306356137=:8972--
