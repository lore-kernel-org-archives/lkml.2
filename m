Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2KMChp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 21:37:45 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:52118 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab2KMChn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 21:37:43 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: <linux-fsdevel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
References: <87objjcfp4.fsf@xmission.com>
	<87625brr76.fsf@tucsk.pomaz.szeredi.hu>
Date: Mon, 12 Nov 2012 18:37:33 -0800
In-Reply-To: <87625brr76.fsf@tucsk.pomaz.szeredi.hu> (Miklos Szeredi's message
	of "Mon, 12 Nov 2012 12:33:33 +0100")
Message-ID: <878va6i5xu.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+LgbKEO/z4vb3XqX64/FXCHNeuhqmChm4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0115]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] userns: Support fuse interacting with multiple user namespaces
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> ebiederm@xmission.com (Eric W. Biederman) writes:
>
>> Use kuid_t and kgid_t in struct fuse_conn and struct fuse_mount_data.
>>
>> The connection between between a fuse filesystem and a fuse daemon is
>> established when a fuse filesystem is mounted and provided with a file
>> descriptor the fuse daemon created by opening /dev/fuse.
>>
>> For now restrict the communication of uids and gids between the fuse
>> filesystem and the fuse daemon to the initial user namespace.
>
> Why?
>
> I think far more logical would be to limit a single instance of the
> filesystem and the daemon to an arbitrary but *single* namespace.
> I.e. one fuse_conn <-> one user namespace.
>
> Is there a reason to treat the initial namespace specially?

Stepwise making this work.

The initial user namespace is special in that is the only user namespace
you can currently mount a filesystem in.

My goal with the posted patch is to support users on the other side of
the vfs that are in multiple user namespaces.  Which basically means
accepting kuid_t and kgid_t values and converting them to uid_t and
gid_t values where needed.

As for creating a version of fuse that can be mounted in different user
namespaces and can communicate with the fuse daemon in the user
namespace the filesystem was mounted in, I have a preliminary patch for
that.  My goal with that patch is to support unprivileged mounts of fuse
without the help of a suid root mount program.  But that patch is more
involved and not quite ready yet.

I want to get to the point that I can enable fuse and user namespaces at
the same time (what this patch allows) and then put in the effort to
fully take advantage of user namespaces.

Eric









