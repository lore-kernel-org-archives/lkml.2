Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456Ab2J0Sah (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 14:30:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758499Ab2J0Sag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 14:30:36 -0400
Message-ID: <508C283C.2090807@redhat.com>
Date: Sat, 27 Oct 2012 13:30:20 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Nix <nix@esperi.org.uk>
CC: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
References: <87mwzdnuww.fsf@spindle.srvr.nix> <20121023143019.GA3040@fieldses.org> <874nllxi7e.fsf_-_@spindle.srvr.nix> <87pq48nbyz.fsf_-_@spindle.srvr.nix> <508AF3FA.4020506@redhat.com> <87wqydx957.fsf@spindle.srvr.nix> <20121026205618.GC8614@thunk.org> <87objpx84k.fsf@spindle.srvr.nix> <20121026211542.GE8614@thunk.org> <87haphx76u.fsf@spindle.srvr.nix> <20121027002258.GB31030@thunk.org> <873910xevu.fsf@spindle.srvr.nix>
In-Reply-To: <873910xevu.fsf@spindle.srvr.nix>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/12 7:45 AM, Nix wrote:
> [nfs people purged from Cc]
> 
> On 27 Oct 2012, Theodore Ts'o verbalised:
> 
>> Huh?  It's not turned on by default.  If you mount with no mount
>> options, journal checksums are *not* turned on.
> 
> ?! it's turned on for me, and though I use weird mount options I don't
> use that one:

journal_async_commit implies journal_checksum:

        {Opt_journal_async_commit, (EXT4_MOUNT_JOURNAL_ASYNC_COMMIT |
                                    EXT4_MOUNT_JOURNAL_CHECKSUM), MOPT_SET},

journal_checksum seems to have broken, at least for me, between 3.3 & 3.4, I think I've narrowed down the commit but not sure yet what the flaw is, will investigate & report back later.  Busy Saturday.

So anyway, turning on journal_async_commit (notionally unsafe) enables journal_checksum (apparently broken).

-Eric

> /dev/main/var   /var        ext4        defaults,nobarrier,usrquota,grpquota,nosuid,nodev,relatime,journal_async_commit,commit=30,user_xattr,acl 1  2
> Default mount options:    (none)
> /dev/mapper/main-var /var ext4 rw,nosuid,nodev,relatime,journal_checksum,journal_async_commit,nobarrier,quota,usrquota,grpquota,commit=30,stripe=16,data=ordered,usrquota,grpquota 0 0
> 
> ...
> 
> Ah! it's turned on by journal_async_commit. OK, that alone argues
> against use of journal_async_commit, tested or not, and I'd not have
> turned it on if I'd noticed that.
> 
> (So, the combinations I'll be trying for effect on this bug are:
> 
>  journal_async_commit (as now)
>  journal_checksum
>  none
> 
> Technically to investigate all possibilities we should try
> journal_async_commit,no_journal_checksum, but this seems so unlikely to
> have ever been tested by anyone that it's not worth looking into...)
> 

