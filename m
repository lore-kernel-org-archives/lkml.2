Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab1I3SaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:30:14 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58984 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab1I3SaM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:30:12 -0400
MIME-Version: 1.0
In-Reply-To: <20110930140409.51c1a94c@tlielax.poochiereds.net>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk>
	<20110930140409.51c1a94c@tlielax.poochiereds.net>
Date: Fri, 30 Sep 2011 13:30:10 -0500
Message-ID: <CAH2r5mvu=dYwai5yoCsy6SO5aLfD-eaYuMXuwZUN3rYqjHZY9Q@mail.gmail.com>
Subject: Re: CIFS kernel module bug
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@samba.org>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        LKML <linux-kernel@vger.kernel.org>,
        PWF Linux <pwf-linux@ucs.cam.ac.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 1:04 PM, Jeff Layton <jlayton@samba.org> wrote:
> On Fri, 30 Sep 2011 14:58:58 +0100
> Anton Altaparmakov <aia21@cam.ac.uk> wrote:
>
>> Hi,
>>
>> Looking at the current kernel (in Linus' repository on github) there is a silly logic bug in the cifs module in fs/cifs/cifsfs.c::cifs_llseek() there is this bit of code:
>>
>>       /*
>>        * origin == SEEK_END || SEEK_DATA || SEEK_HOLE => we must revalidate
>>        * the cached file length
>>        */
>>       if (origin != SEEK_SET || origin != SEEK_CUR) {
>>
>> The logical or should be a logical and, i.e. this should be:
>>
>>       if (origin != SEEK_SET && origin != SEEK_CUR) {
>>
>> As the code is at present that line is ALWAYS true because origin is ALWAYS either != SEEK_SET or != SEEK_CUR as if it equals one it cannot equal the other and vice versa…
>>
>> So at the moment it always does the revalidation instead of only for SEEK_END, SEEK_DATA, and SEEK_HOLE.
>>
>> Best regards,
>>
>>       Anton
>
>
> Haha, good catch. Care to roll up a patch to fix that?
>
> --
> Jeff Layton <jlayton@samba.org>
>


Yes - obviously that code was wrong, fortunately not a disaster.
Thanks for pointing this out.  If you don't want to write up
the patch let us know and we will make the trivial fix.



-- 
Thanks,

Steve
