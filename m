Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab1JQOqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 10:46:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39512 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab1JQOqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 10:46:17 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: 645366@bugs.debian.org, fuse-devel@lists.sourceforge.net,
        "brian m. carlson" <sandals@crustytoothpaste.net>, rjw@sisk.pl,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Bug#645366: [fuse-devel] Hang and suspend failure after FUSE server killed (3.1-rc7)
References: <20111014225213.GA5705@crustytoothpaste.ath.cx>
	<1318824752.3340.7.camel@deadeye>
	<87ty77lmts.fsf@tucsk.pomaz.szeredi.hu>
	<1318861889.3340.23.camel@deadeye>
Date: Mon, 17 Oct 2011 16:45:27 +0200
In-Reply-To: <1318861889.3340.23.camel@deadeye> (Ben Hutchings's message of
	"Mon, 17 Oct 2011 15:31:28 +0100")
Message-ID: <87obxfllrs.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <ben@decadent.org.uk> writes:

> On Mon, 2011-10-17 at 16:22 +0200, Miklos Szeredi wrote:
>> Ben Hutchings <ben@decadent.org.uk> writes:
>> 
>> > On Fri, 2011-10-14 at 22:52 +0000, brian m. carlson wrote:
>> >> Package: linux-2.6
>> >> Version: 3.1.0~rc7-1~experimental.1
>> >> Severity: normal
>> >> 
>> >> This morning I was backing up my laptop to another computer via sshfs
>> >> (and fuse).  The afio archiver was writing to this sshfs-mounted
>> >> location.  I decided to abort the operation with Ctrl-C, which caused
>> >> the sshfs mount to become unmounted; however, afio was apparently not
>> >> affected by the SIGINT (probably because processes in disk IO are
>> >> unkillable).
>> >> 
>> >> Several hours later, I attempted to suspend my computer and it failed to
>> >> do so. The kernel log (attached) indicated that the afio process from
>> >> hours before was preventing the suspend.  Since processes waiting on
>> >> disk IO are unkillable (IMO a bug) and the underlying device to which
>> >> afio was writing was long gone, I was forced to reboot the machine in
>> >> order to get it to suspend.  If I had not noticed that the machine had
>> >> failed to suspend, it could have stayed running in my bag and seriously
>> >> overheated.
>> >
>> > This seems to be a bug in FUSE.  Is this known about?  If not, could
>> > someone look into this?
>> 
>> It's a bug in the fuse-freezer interaction.  Yes, it is known.
> [...]
>
> But the FUSE server was already killed; shouldn't that cause outstanding
> requests to fail immediately?

Yes it should.

But my guess is that the server wasn't actually killed, otherwise the
archiver program would have just gotten ENOTCONN errors and exited.  The
fact that "afio" had hung means that sshfs also hung.  We can't prove or
disprove this without a process listing.

The reason for sshfs hanging could be due to one of the bugs that were
fixed in the sshfs-2.3 version.  E.g.:

	* Fix cleanup when ssh connection is terminated.  This prevents
	sshfs hanging when the server is rebooted, for example.

Thanks,
Miklos
