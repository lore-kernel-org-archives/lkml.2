Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934809Ab1JEOtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 10:49:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57448 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab1JEOtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 10:49:45 -0400
MIME-Version: 1.0
In-Reply-To: <1317798113.29415.270.camel@pasglop>
References: <1317653420-21404-3-git-send-email-mason@myri.com>
 <CA+55aFyyx99Z4=x-Twp7JCpU=JHPzP8HRdLc4H3NOGHNQq9jCw@mail.gmail.com>
 <1317742838.29415.217.camel@pasglop> <CA+55aFzFWC3Acp0bwx33CgUZ9NgiDdJ8H=yNOdb0xmLsAAJZxQ@mail.gmail.com>
 <1317744493.29415.238.camel@pasglop> <CA+55aFyV9uqTt6UHA2wsAdRHHCSAtCSmoO2d3dm62HAo+s75Sg@mail.gmail.com>
 <1317749439.29415.251.camel@pasglop> <CA+55aFyOcb2y1QVaTNssWFU+nCee8RSs9-wZ-ARnFWcF5MdGSA@mail.gmail.com>
 <1317798113.29415.270.camel@pasglop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 5 Oct 2011 07:49:24 -0700
X-Google-Sender-Auth: 1H6NnItrtdU1vC0GVyH5-ztAMEY
Message-ID: <CA+55aFwoeC+X=XWWJ7HFUfz6tZmJW6PMmkGcRM5otLbyGt587Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] pci: Clamp pcie_set_readrq() when using "performance" settings
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jon Mason <mason@myri.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 5, 2011 at 12:01 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
>> We just don't the hell know, do we?
>
> Well, we do with some confidence :-) Or rather what we do know is what
> you have today in your tree is broken.

You're missing the point.

Repeat after me: late -rc series is not when we test these kinds of things.

This point in time is when we *revert* commits that are broken. We fix
them if there is absolutely no question about the fix, but that simply
isn't true here. Even if the patches "improve" something, there is no
way I hell that I believe that we suddenly don't need to worry about
MPS any more.

How hard is this to just understand? It's not about "we can improve
things". It's about "it's f*%!ing late in the rc series, we're not
dicking around any more!".

So quite frankly, if you don't like the code now, send me a revert for
all the mess. BUT DON'T ARGUE FOR CHANGES THAT AREN'T 100% ROCK SOLID.

So the current situation is that MPS is simply *disabled*. All the
crap code simply doesn't matter at all, because nobody will run it.
Arguing that it is "broken" is stupid, because the only people that
that brokenness would ever matter for are the people like you who are
testing things out - not actual users.

Comprende?

Think of it like a stable kernel. We don't mess around with things
that don't matter and nobody will hit. We don't do "development" in
the late -rc, and yet that is what the MPS patches in question have
been doing.

IT IS TOO LATE FOR CRAP LIKE THAT. WE TURNED IT OFF.

                       Linus
