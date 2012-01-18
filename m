Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab2ARDK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 22:10:29 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:34248 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab2ARDK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 22:10:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Will Drewry <wad@chromium.org>
Cc: Andrew Lutomirski <luto@mit.edu>, Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        oleg@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH PLACEHOLDER 1/3] fs/exec: "always_unprivileged" patch
References: <1326411506-16894-1-git-send-email-wad@chromium.org>
	<CA+55aFz4mJU2E2BPzZyVQ52V_ytg_8fyAH+BV_uYHVXBM2wqDw@mail.gmail.com>
	<CAObL_7FErN5CHmfSehJYcM0_Lz-WTywG7cHe2jZyQbf-GkOQjg@mail.gmail.com>
	<CA+55aFzzRNHfSo-1DyzsAwYvj1Da-vyhMQP-OdrA-rWywsebcg@mail.gmail.com>
	<CAObL_7F8aYPDQ1xTFjOxWgoZfrtGNFVgMe2Ld61_=D+YY427qA@mail.gmail.com>
	<CA+55aFxSgYFp1psum3amgqqsT-rrvGd1T8BXJSA-mgd1EdHrwg@mail.gmail.com>
	<20120114133053.GY7180@jl-vm1.vm.bytemark.co.uk>
	<CA+55aFwZ-=s3S9wmRSfW8-tbcJct+GWedQi8Dc8RW75NaqB10A@mail.gmail.com>
	<4F133423.5070007@schaufler-ca.com>
	<CAObL_7FE1NGJLNu-xUkyzCfZ7OSHO16p-4Lk2h5emkE7CGxC_Q@mail.gmail.com>
	<4F1345DB.8040303@schaufler-ca.com>
	<CAObL_7F4hEvdyJLNhodOOETTv-Dur8gEadLkzESQWFC2C57t7w@mail.gmail.com>
	<CABqD9haumYV6SizAXeR9Os69QgYEkW6fBC27dAYhOr-8U=p6_A@mail.gmail.com>
Date: Tue, 17 Jan 2012 19:12:41 -0800
In-Reply-To: <CABqD9haumYV6SizAXeR9Os69QgYEkW6fBC27dAYhOr-8U=p6_A@mail.gmail.com>
	(Will Drewry's message of "Sun, 15 Jan 2012 20:04:13 -0600")
Message-ID: <m18vl5900m.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+EwrRdFDk8hoADkP/U3hcuVAvX94fOTRo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Drewry <wad@chromium.org> writes:

> One consideration could be to add do_exit()s at known DAC transitions
> (set*id, fcaps). I don't know if that'd be wise, but it would remove
> some described ambiguity.  The same could be done with exec when the
> (e)uid/gid/fcaps change.  However, none of that helps with the opaque
> LSM data, so that'd have to be left up to the LSMs and the LSM_* flag
> you've added.

I went through and audited userspace recently and I could not find
anything that did not handle setuid failing.  It looks like kernel
developers are not the only ones who learned from the
sendmail/capabilities problem.

Eric


