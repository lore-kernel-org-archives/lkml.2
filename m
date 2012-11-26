Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2KZOjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 09:39:15 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:37986 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab2KZOjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 09:39:11 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Ian Kent <raven@themaw.net>, autofs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sukadev@linux.vnet.ibm.com, serge.hallyn@canonical.com,
        Al Viro <viro@zeniv.linux.org.uk>
References: <87obipehbt.fsf@tucsk.pomaz.szeredi.hu>
	<1353642304.2309.25.camel@perseus.themaw.net>
	<1353672540.6699.18.camel@perseus.themaw.net>
	<874nkgwfw0.fsf@tucsk.pomaz.szeredi.hu>
	<1353723813.2348.48.camel@perseus.themaw.net>
	<1353724641.2348.56.camel@perseus.themaw.net>
	<878v9rmcgc.fsf@xmission.com>
	<CAJfpegvQGhzDvQt=OBf=GVQF2gDynTp6F+zO-dn5skFLtukFCQ@mail.gmail.com>
	<87lidqfx3u.fsf@xmission.com>
	<1353885956.2323.4.camel@perseus.themaw.net>
	<1353896968.2323.7.camel@perseus.themaw.net>
	<CAJfpegsqwd57NdHVhwfdNjauj8HKJb=x+2GAZtJQ8vLdt+A=sw@mail.gmail.com>
Date: Mon, 26 Nov 2012 08:38:58 -0600
In-Reply-To: <CAJfpegsqwd57NdHVhwfdNjauj8HKJb=x+2GAZtJQ8vLdt+A=sw@mail.gmail.com>
	(Miklos Szeredi's message of "Mon, 26 Nov 2012 09:05:46 +0100")
Message-ID: <87boekzawt.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/rfApXq9mKANH8GooRK1mlLLbhxorU0fw=
X-SA-Exim-Connect-IP: 75.135.205.0
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0004]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/2] autofs4: allow autofs to work outside the initial PID namespace
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Mon, Nov 26, 2012 at 3:29 AM, Ian Kent <raven@themaw.net> wrote:
>>> > > MS_UNBINDABLE says:  skip this mount when copying a mount tree, such
>>> > > as when the mount namespace is cloned.
>>> > >
>>> > > If you set MS_UNBINDABLE on autofs mounts then they will simply not
>>> > > appear in a cloned namespace.  Which sounds like a good idea,  no?
>>> >
>>> > Good point.  If the desire is for a mount to be managed by autofs
>>> > setting MS_UNBINDABLE seems required.
>>>
>>> Arrgh, I know that's something I should have looked into long ago.
>>> The fact is that autofs mounts are directly related to a specific path
>>> defined by automount maps that are associated with the daemon so bind
>>> mounting them elsewhere makes no sense.
>>
>> Except, AFAICS, they do appear in the clone.
>
> Hmm, yes, apparently the semantics of MS_UNBINDABLE only apply to
> actual bind mounts not to namespace cloning. Even though the two
> operations are closely related.  Not sure why this is so, but it is
> probably not a good idea to change the semantics at this point.

And for whatever reason this appears deliberate.

CL_COPY_ALL in copy_tree allows the copy.

The selected semantics of namespace sharing tend to mystify me.

So I don't know how much MS_UNBINDABLE helps over MS_PRIVATE.  Both
prevent propogation of changes to other namespaces.  I don't know how
much using MS_UNBINDABLE to also prevent bind mounts helps.

Eric

