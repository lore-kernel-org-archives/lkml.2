Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab1EYVGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:06:02 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62284 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab1EYVGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:06:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=xtfx.me; s=google;
        h=mime-version:x-originating-ip:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-type;
        b=MxSFgOMIdgi5z5DCzjtkFmsk8xJm7PQJPB45MhpY/FRqyBAgDgt6eoYz9nqxN6o+jA
         jfKAb9yJeCE82c2hEfiAgJWIKgEiKsGsjdTZhctL26JZ6GIGgUHcMjgxKhnA2eHZaktV
         8hrL/00xxsdURzm2AvYBJUGIlwO+c0Ja+HlhQ=
MIME-Version: 1.0
X-Originating-IP: [98.103.195.251]
In-Reply-To: <m1wrhh3z62.fsf@fess.ebiederm.org>
References: <m1wrhh3z62.fsf@fess.ebiederm.org>
From: C Anthony Risinger <anthony@xtfx.me>
Date: Wed, 25 May 2011 16:05:39 -0500
Message-ID: <BANLkTikW4vJbC8kcLSKuemUBbu36SO6hwg@mail.gmail.com>
Subject: Re: [GIT PULL] Namespace file descriptors for 2.6.40
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 4:05 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> This tree adds the files /proc/<pid>/ns/net, /proc/<pid>/ns/ipc,
> /proc/<pid>/ns/uts that can be opened to refer to the namespaces of a
> process at the time those files are opened, and can be bind mounted to
> keep the specified namespace alive without a process.
>
> This tree adds the setns system call that can be used to change the
> specified namespace of a process to the namespace specified by a system
> call.

i just have a quick question regarding these, apologies if wrong place
to respond -- i trimmed to lists only.

if i understand correctly, mount namespaces (for example), allow one
to build such constructs as "private /tmp" and similar that even
`root` cannot access ... and there are many reasons `root` does not
deserve to completely know/interact with user processes (FUSE makes a
good example ... just because i [user] have SSH access to a machine,
why should `root`?)

would these /proc additions break such guarantees?  IOW, would it now
become possible for `root` to inject stuff into my private namespaces,
and/or has these guarantees never existed and i am mistaken?  is there
any kind of ACL mechanism that endows the origin process (or similar)
with the ability to dictate who can hold and/or interact with these
references?

Thanks for your time,

-- 

C Anthony
