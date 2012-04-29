Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab2D2PDI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 11:03:08 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61522 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab2D2PDF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 11:03:05 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20120306161224.GE9978@shadowen.org>
References: <1329491451-14960-1-git-send-email-apw@canonical.com>
	<87pqcr9db4.fsf@tucsk.pomaz.szeredi.hu>
	<20120306161224.GE9978@shadowen.org>
Date: Sun, 29 Apr 2012 17:03:04 +0200
Message-ID: <CA+icZUVTkfMxK=zHnF+9iN0XWorApLKL4QJ0U3T01pndaVyUOA@mail.gmail.com>
Subject: Re: [PATCH 1/1] overlayfs: apply device cgroup and security
 permissions to overlay files
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 5:12 PM, Andy Whitcroft <apw@canonical.com> wrote:
> On Mon, Mar 05, 2012 at 06:18:23PM +0100, Miklos Szeredi wrote:
>> Andy Whitcroft <apw@canonical.com> writes:
>>
>> > When checking permissions on an overlayfs inode we do not take into
>> > account either device cgroup restrictions nor security permissions.
>> > This allows a user to mount an overlayfs layer over a restricted device
>> > directory and by pass those permissions to open otherwise restricted
>> > files.
>> >
>> > Use devcgroup_inode_permission() and security_inode_permission() against
>> > the underlying inodes when calculating ovl_permission().
>>
>> Andy,
>>
>> Thanks for the patch.
>>
>> __devcgroup_inode_permission() and security_inode_permission() are not
>> exported to modules, so this will not work if overlayfs is a module.
>>
>> We could export those but I think a better solution is to split out the
>> part of inode_permission() that doesn't check for a read-only fs and
>> export that.
>
> Yeah that makes much more sense.  I got caught out by some exports
> required for aufs3 which was also applied in my test environment.
>
> How about the following pair of patches?
>
> -apw
> --

Hi,

what is the status of this patch?

Ubuntu has it included in precise kernel and it fixes a security issues as well.
[1] says:
CVE-2012-0055
BugLink: http://bugs.launchpad.net/bugs/915941
BugLink: http://bugs.launchpad.net/bugs/918212

What's up with the followup (splitted) patches which should replace
this single one?
My inbox says:
[PATCH 1/2] inode_only_permission: export inode level permissions checks
[PATCH 2/2] overlayfs: switch to use inode_only_permissions

As I build OverlayFS as module those two new patches would be much appreciated.
To quote Miklos:
"__devcgroup_inode_permission() and security_inode_permission() are not
exported to modules, so this will not work if overlayfs is a module."

Thanks for any clarification in advance.

- Sedat -

[1] http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-precise.git;a=commit;h=59aa87f808b13463bc717ad69362b5372f6c5574
