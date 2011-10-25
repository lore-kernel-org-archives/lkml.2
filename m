Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab1JYAn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 20:43:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59632 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab1JYAn1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 20:43:27 -0400
MIME-Version: 1.0
In-Reply-To: <20111024172842.GA13556@sergelap>
References: <CALQRfL51U=cuLdVUpFXTog++3WwMjJB+9S6T8gVibC5gdGa5JQ@mail.gmail.com>
	<1318974898-21431-1-git-send-email-serge@hallyn.com>
	<1318974898-21431-6-git-send-email-serge@hallyn.com>
	<14652.1319014868@redhat.com>
	<20111024144334.GA26603@hallyn.com>
	<CALQRfL4zCbzr_Fa0ySi96j06nw7ifocCxUjYUs6vXxeNvjCutQ@mail.gmail.com>
	<20111024172842.GA13556@sergelap>
Date: Mon, 24 Oct 2011 17:43:25 -0700
X-Google-Sender-Auth: L_XZV6BRQf2wCd4rLFvo2so-sXU
Message-ID: <CALQRfL7ZNv9+7tooJC8x8Pmz62QtnJ+-pVFRy_YspCG1BhZKzg@mail.gmail.com>
Subject: Re: [PATCH 05/10] user namespace: clamp down users of cap_raised
From: "Andrew G. Morgan" <morgan@kernel.org>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        akpm@linux-foundation.org, oleg@redhat.com, richard@nod.at,
        mikevs@xs4all.net, segoon@openwall.com, gregkh@suse.de,
        eparis@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 10:28 AM, Serge E. Hallyn
<serge.hallyn@canonical.com> wrote:
> Quoting Andrew G. Morgan (morgan@kernel.org):
>> Serge,
>>
>> It seems as if this whole thing is really idiomatic. How about?
>>
>> #define IN_ROOT_USER_NS_CAPABLE(cap)  \
>>    ((current_user_ns() == &init_user_ns) && cap_raised(current_cap(), cap))
>
> My objection to this was that it seems to encourage others to use it :)  I'm
> not sure we want that.  Also, IN_ROOT_USER_NS seems more generally useful.

What is driving the choice of when its appropriate? How can a
developer determine this? If you make it hard, presumably folk won't
do it by default, but will that create a burdon on others to go round
patching things like this up?

> But if I'm the only one who feels this way I'll go ahead and do it...

I'm more of a optimize for a human to read the source code (ie. debug
a problem) kind of person. If IN_ROOT_USER_NS is useful, you could
always define IN_ROOT_USER_NS_CAPABLE in terms of IN_ROOT_USER_NS &&
... and provide both.

I guess I'm unclear, however, when you want developers to use one or
the other variant of the basic capable() functionality. Since I'm not
clear, I'm suspecting this is a fragile situation.

Cheers

Andrew
