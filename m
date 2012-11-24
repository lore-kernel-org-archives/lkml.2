Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2KXWfc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 17:35:32 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:48912 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab2KXWf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 17:35:29 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Ian Kent <raven@themaw.net>, autofs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sukadev@linux.vnet.ibm.com, serge.hallyn@canonical.com
References: <87obipehbt.fsf@tucsk.pomaz.szeredi.hu>
	<1353642304.2309.25.camel@perseus.themaw.net>
	<1353672540.6699.18.camel@perseus.themaw.net>
	<874nkgwfw0.fsf@tucsk.pomaz.szeredi.hu>
	<1353723813.2348.48.camel@perseus.themaw.net>
	<1353724641.2348.56.camel@perseus.themaw.net>
	<878v9rmcgc.fsf@xmission.com>
	<CAJfpegvQGhzDvQt=OBf=GVQF2gDynTp6F+zO-dn5skFLtukFCQ@mail.gmail.com>
Date: Sat, 24 Nov 2012 14:35:17 -0800
In-Reply-To: <CAJfpegvQGhzDvQt=OBf=GVQF2gDynTp6F+zO-dn5skFLtukFCQ@mail.gmail.com>
	(Miklos Szeredi's message of "Sat, 24 Nov 2012 22:12:58 +0100")
Message-ID: <87lidqfx3u.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18weiMq7d4hnrXyfViU0zQ/+cje/WvFufo=
X-SA-Exim-Connect-IP: 75.135.205.0
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0035]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/2] autofs4: allow autofs to work outside the initial PID namespace
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Sat, Nov 24, 2012 at 1:07 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Ian Kent <raven@themaw.net> writes:
>>
>>> On Sat, 2012-11-24 at 10:23 +0800, Ian Kent wrote:
>>>> On Fri, 2012-11-23 at 15:30 +0100, Miklos Szeredi wrote:
>
>>>> AFAICS autofs mounts mounted with MS_PRIVATE in the initial namespace do
>>>> propagate to the clone when it's created so I'm assuming subsequent
>>>> mounts would also. If these mounts are busy in some way they can't be
>>>> umounted in the clone unless "/" is marked private before attempting the
>>>> umount.

Subsequent mounts after the clone do not have a mechanism to propogate
with MS_PRIVATE.  As creating a new mount namespaces is essentially
an instance of mount --bind.  Those semantics are a little unintuitive
I have to admit.

>>> This may sound stupid but if there something like, say, MS_NOPROPAGATE
>>> then the problem I see would pretty much just go away. No more need to
>>> umount existing mounts and container instances would be isolated. But, I
>>> guess, I'm not considering the possibility of cloned of processes as
>>> well .... if that makes sense, ;)
>>
>> Something is very weird is going on.  MS_PRIVATE should be the
>> MS_NOPROPOGATE you are looking for.  There is also MS_UNBINDABLE.
>> which is a stronger form of MS_PRIVATE and probably worth play with.
>>
>
> MS_UNBINDABLE says:  skip this mount when copying a mount tree, such
> as when the mount namespace is cloned.
>
> If you set MS_UNBINDABLE on autofs mounts then they will simply not
> appear in a cloned namespace.  Which sounds like a good idea,  no?

Good point.  If the desire is for a mount to be managed by autofs
setting MS_UNBINDABLE seems required.

Eric

