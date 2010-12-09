Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab0LIS0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:26:42 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:54100 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab0LIS0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:26:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QGVKs8YORkZyx+tj2pvyzaLa/LMEUGFHKZw1O+C+HYkTu6vnwT+D/i1cbWEACi9nA2
         l+IkzVK/yEXLcgZJSoQq/wPPzxBq/YLzxNeLNYrwF62FS5tVwMWfJdElZk9cobd7sJWY
         Dhq6oHEPg6vpg+7Uk2EnR+uoBiZbC03819Bsk=
MIME-Version: 1.0
In-Reply-To: <20101209070952.24793c23@barsoom.rdu.redhat.com>
References: <1291568855-22604-1-git-send-email-bernhard@bwalle.de>
	<20101206095725.78422138@tlielax.poochiereds.net>
	<20101206101214.52a24415@tlielax.poochiereds.net>
	<20101206163506.56232lqqhc5c3co4@webmail.df.eu>
	<20101206103836.0714369a@tlielax.poochiereds.net>
	<4D00C02C.4070006@suse.de>
	<20101209070952.24793c23@barsoom.rdu.redhat.com>
Date: Thu, 9 Dec 2010 12:26:39 -0600
Message-ID: <AANLkTimm=Ca51y-4kZwpBCiBoSUjxz=maYz6J=ys2z6C@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add information about noserverino
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Suresh Jayaraman <sjayaraman@suse.de>, Bernhard Walle <bernhard@bwalle.de>,
        sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 6:09 AM, Jeff Layton <jlayton@redhat.com> wrote:
> On Thu, 09 Dec 2010 17:10:28 +0530
> Suresh Jayaraman <sjayaraman@suse.de> wrote:
>
>> On 12/06/2010 09:08 PM, Jeff Layton wrote:
>> > On Mon, 06 Dec 2010 16:35:06 +0100
>> > Bernhard Walle <bernhard@bwalle.de> wrote:
>> >
>> >>
>> >> Zitat von Jeff Layton <jlayton@redhat.com>:
>> >>
>> >>>
>> >>> I'm still not sure I like this patch however. It potentially means a
>> >>> lot of printk spam since these things have no ratelimiting. It also
>> >>> doesn't tell me anything about which server might be giving me grief.
>> >>>
>> >>> Maybe this should be turned into a cFYI?
>> >>
>> >> Well, if I see it in the kernel log, it doesn't matter if it's info or
>> >> something else.
>> >>
>> >>> The bottom line though is that running 32-bit applications that were
>> >>> built without -D_FILE_OFFSET_BITS=64 on a 64-bit kernel is a very bad
>> >>> idea. It would be nice to be able to alert users that things aren't
>> >>> working the way they expect, but I'm not sure this is the right place
>> >>> to do that.
>> >>
>> >> Well, but there *are* such application (in my case it was Softmaker Office
>> >> which is a proprietary word processor) and it's quite nice if you know
>> >> how you can workaround it when you encounter such a problem. That's all.
>> >>
>> >
>> > Sure...but this problem is not limited to CIFS. Many modern filesystems
>> > use 64-bit inodes. Running this application on XFS or NFS for instance
>> > is likely to give you the same trouble. You just hit it on CIFS because
>> > the server happened to give you a very large inode number.
>> >
>> > If we're going to add printk's for this situation, it probably ought to
>> > be in a more generic place.
>> >
>>
>> By generic place, did you mean at the VFS level? I think at VFS level,
>> there is little information about the Server or underlying fs and this
>> information doesn't seem too critical that VFS should warn/care much about.
>>
>> May be sticking to a cFYI along with Server detail is a good idea?
>>
> My poing was mainly that there's nothing special about CIFS in this
> regard, other than the fact that servers regularly send us inodes that
> are larger than 2^32. Why should we do this for cifs but not for nfs,
> xfs, ext4, etc?
>
> The filldir function gets a dentry as an argument, so it could
> reasonably generate a printk for this. I'm also not keen on
> the printk recommending noserverino for this. That has its own
> drawbacks.
>
> A cFYI for this sort of thing seems reasonable however.

I agree that a cFYI is reasonable.  The next obvious question is: do
we need to add code to generate unique 32 bit inode numbers
that don't collide (as IIRC Samba does by xor the high and low 32
bits of the inode number) when the app can't support ino64
I would prefer not to go back to noserverino since that has worse
drawbacks.



-- 
Thanks,

Steve
