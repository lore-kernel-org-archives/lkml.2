Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab1CUAyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 20:54:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752382Ab1CUAyT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 20:54:19 -0400
MIME-Version: 1.0
In-Reply-To: <20110319085802.GA18336@sepie.suse.cz>
References: <20110319085802.GA18336@sepie.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 Mar 2011 17:53:24 -0700
Message-ID: <AANLkTin5vYaU83K0YOdD1OgCS24LA8XBSvNfmGFnjhGF@mail.gmail.com>
Subject: Re: [GIT] kbuild core updates for 2.6.39-rc1
To: Michal Marek <mmarek@suse.cz>
Cc: bp@alien8.de, dot@dotat.at, mikew@google.com, randy.dunlap@oracle.com,
        u.kleine-koenig@pengutronix.de, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 19, 2011 at 1:58 AM, Michal Marek <mmarek@suse.cz> wrote:
>
> * Section mismatch analysis enabled by default
>  - there are only a few warnings for defconfig builds,
>    all{yes,mod}config still has a lot of them. Depending on the general
>    perception of this change, we might disable it later in the rc phase
>    again.

No.

We don't enable stuff like this by default. Not when it actually
changes some really fundamental compiler flags, and thus the whole "we
can disable it late in -rc again" is a totally broken option, since if
we have any compiler issues, we'd want to know it early.

And we _know_ we are going to disable it, since it enables the "don't
inline" flag to gcc for called-once functions. So there's no question
at all what the default should be in any release kernel.

Anyway - in general, enabling options like this had better have some
_seriously_ major reasons. IOW, major known issues that just have to
be sorted out and cannot be sorted out any other way. That doesn't
seem to be the case here.

WE DO NOT EVER ENABLE NEW THINGS BY DEFAULT. I know, I know - every
developer always thinks that _his_ code is special and magically so
important that it should be enabled by default, but no, that is simply
not the case. The only reason to enable something by default is that
it used to never be a config option in the first place, so if somebody
builds a new kernel, and he used to just silently get the feature,
then the new config option is still on by default.

Not pulling. This is a pet peeve of mine. We don't use "set to 'y' on
default" as a way to trick people into enabling code. No, no, no.

                             Linus
