Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab0KMCDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 21:03:16 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59857 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab0KMCDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 21:03:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Cfx2usuOkYTNBFtXnBQWzLuIFpjsTHHvnlBSy64SoIg7wjSEvA6CgUUSO/9gVPAppM
         Nb3wjzKB78q2EONSZs6dIEgCniJe5TB9qMfIIr/MwREefWUXW6lMsHPgzr8CgnI9F6fg
         148vPmzf2jrFyxyIHcnbBPJioalv6Z/+tFqag=
Message-ID: <4CDDF1DB.1020707@garzik.org>
Date: Fri, 12 Nov 2010 21:03:07 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: James Bottomley <James.Bottomley@suse.de>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] SCSI queuecommand API change for 2.6.37-rc1
References: <1289606118.3015.539.camel@mulgrave.site> <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com>
In-Reply-To: <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2010 08:42 PM, Linus Torvalds wrote:
> On Fri, Nov 12, 2010 at 3:55 PM, James Bottomley
> <James.Bottomley@suse.de>  wrote:
>>
>> This patch set contains a single patch modifying the SCSI queuecommand
>> host template API to go from being called with the host lock held to
>> being called locklessly.  The transformation is a directly equivalent
>> one (i.e. the locking is simply pushed into each HBA) but will form the
>> basis for optimising locking in the driver patch for the next merge
>> window.
>
> Ok, so we talked about this patch at the KS, but I never saw it.
>
> And now seeing it, I do detest it.
>
> Why? Because if some driver gets missed for any reason (notably if
> it's currently out of tree, and gets merged later), afaik there will
> be ABSOLUTELY ZERO compiler warnings or anything about it, because you
> kept the "queuecommand" function exactly the same. Whether it's a
> locked or non-locked one, it always is of type
[...]
> So please: when you change the semantics of a function, just change
> the function prototype (or function name) at the same time. Especially
> when it comes to a driver interface, so that the drivers don't get
> taken by surprise.
>
> Type safety and automatic compiler warnings really are our friends.
> Especially when the patch was presumably mostly auto-generated, and
> maybe the script missed something, and missing some conversion has
> such subtle effects.

That is precisely what I mentioned in the original patch:
http://marc.info/?l=linux-ide&m=128891665713984&w=2

And brought this up again when James merged my patch:
http://marc.info/?l=linux-scsi&m=128943169802009&w=2

I even volunteer[ed] to do the work to make it happen...

	Jeff


P.S.  My patch was not auto-generated.  One of the two previous attempts 
at this change was scripted w/ coccinelle, and it created obvious 
locking problems.

