Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab0GIBD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 21:03:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48580 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab0GIBDZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 21:03:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oDrpBBqg3h5RLfSa2rIvNXunlLah2bsJsL+fEV/BN4//V/BPbo4a5h4HXQIUZed8Nx
         LaLzPFswXdD4aFdIeWUbyqggpeyMFLjSNhKvqZD9Wf6NuZnNOTRK+1IrKUkwsfe7RQcU
         kx5R5mNHlGvbyBbkm7S7Mhhu9h6Czqr++0o+I=
MIME-Version: 1.0
In-Reply-To: <20100708204945.01ca1236@corrin.poochiereds.net>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
	<TXb9XdQzJoD.A.DhB.SMmNMB@chimera>
	<20100708204945.01ca1236@corrin.poochiereds.net>
Date: Fri, 9 Jul 2010 11:03:23 +1000
Message-ID: <AANLkTikt1cJTq7_yYlISBYuAXlF2_X1mausSsr1j6l85@mail.gmail.com>
Subject: Re: [Bug #16306] 2.6.35-rc3 BUG: unable to handle kernel NULL pointer 
	dereference at 0000000000000048 cifs_show_options
From: Andrew Hendry <andrew.hendry@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It might not be a regression, and so far i haven't been able to reproduce.
Its seems to be related to suspend/resume interface up/down and mount/unmount.
Also potentially with cifs waiting for a NAS to spinup to complete mount.

On Fri, Jul 9, 2010 at 10:49 AM, Jeff Layton <jlayton@redhat.com> wrote:
> On Fri,  9 Jul 2010 01:41:39 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
>> This message has been generated automatically as a part of a summary report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.34.  Please verify if it still should be listed and let the tracking team
>> know (either way).
>>
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=16306
>> Subject               : 2.6.35-rc3 BUG: unable to handle kernel NULL pointer dereference at 0000000000000048 cifs_show_options
>> Submitter     : Andrew Hendry <andrew.hendry@gmail.com>
>> Date          : 2010-06-26 10:46 (13 days old)
>> Message-ID    : <AANLkTilhTrEBYZd4HxeXQk8B6-yV8rCJ2C0jXsEREgIR@mail.gmail.com>
>> References    : http://marc.info/?l=linux-kernel&m=127754922110501&w=2
>> Handled-By    : Jeff Layton <jlayton@redhat.com>
>>
>>
>
> Not sure if this is a new bug or not...
>
> I don't think this is really a CIFS bug, per-se. It seems like the
> problem may be that the iterator for /proc/pid/mountinfo is not
> sufficiently protected against removal from the vfsmount list.
>
> Filesystems don't seem to be expected to do any locking in their
> show_options routines though so I'm guessing that something is borked
> in the generic vfs layer.
>
> Either that or this is some sort of generic mem corruption? I'm open to
> input from others that have a better grasp of this stuff at the VFS
> layer...
>
> --
> Jeff Layton <jlayton@redhat.com>
>
