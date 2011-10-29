Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413Ab1J2PDi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 11:03:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38370 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744Ab1J2PDg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 11:03:36 -0400
MIME-Version: 1.0
In-Reply-To: <4EA85764.60309@xenotime.net>
References: <4EA85764.60309@xenotime.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 29 Oct 2011 08:03:14 -0700
X-Google-Sender-Auth: Gpcq_HzHns9gzAczO9etU9T5-II
Message-ID: <CA+55aFyghT3vx5Y0dPsa4sXpTV_vd0FAtzXurv1oh_26P8G7zQ@mail.gmail.com>
Subject: Re: [git pull] Documentation: DocBook/drm, basic copyediting
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Witten <mfwitten@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 11:54 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>
> Note:  Please check that I haven't mucked up somewhere, because this:
> $ git diff -M --stat --summary master..HEAD
>
> shows me more than the changes above.

You have indeed messed up  - there are extraneous merges there. But
that's not why your diff fails: your diff probably fails because
"master" is ahead of your base, so when you ask for the diff between
master and HEAD, you get a diff that contains (the reverse of)
everything that I have done that isn't in your tree.

For diffs, you likely want to look at the diff between the "merge
base" and your HEAD. Which is what "..." (triple dot) does, so you can
probably do

   git diff -M --stat --summary master...HEAD

and it should give you the right thing.

However, I really don't see why you have two extra merges on top of
that commit series.

                            Linus
