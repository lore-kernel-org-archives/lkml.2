Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab2LMWn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:43:59 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:55163 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab2LMWn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:43:57 -0500
MIME-Version: 1.0
In-Reply-To: <87zk1hshk7.fsf_-_@xmission.com>
References: <87ip88uw4n.fsf@xmission.com> <50CA2B55.5070402@amacapital.net>
 <87mwxhtxve.fsf@xmission.com> <87zk1hshk7.fsf_-_@xmission.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Dec 2012 14:43:36 -0800
X-Google-Sender-Auth: Sg-ToGcivWMpMLSv7KfbtZhxbDU
Message-ID: <CA+55aFwXnFEFXbkwFPq9xt30xp2_6jfpBLd3E2bms79KKK=V1Q@mail.gmail.com>
Subject: Re: [RFC][PATCH] Fix cap_capable to only allow owners in the parent
 user namespace to have caps.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 2:39 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Andy Lutomirski pointed out that the current behavior of allowing the
> owner of a user namespace to have all caps when that owner is not in a
> parent user namespace is wrong.
>
> This is a bug introduced by the kuid conversion which made it possible
> for the owner of a user namespace to live in a child user namespace.  I
> goofed and totally missed this implication.

Hmm. Shouldn't this be cc: stable if it was introduced in the kuid
conversion? Or is it only an issue with your new namespace tree (which
I haven't pulled yet)?

              Linus
