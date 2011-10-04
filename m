Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab1JDRbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:31:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:33196 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932788Ab1JDRbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:31:01 -0400
Subject: Re: [PATCH 2/3] pci: Clamp pcie_set_readrq() when using
 "performance" settings
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jon Mason <mason@myri.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>
In-Reply-To: <CA+55aFyV9uqTt6UHA2wsAdRHHCSAtCSmoO2d3dm62HAo+s75Sg@mail.gmail.com>
References: <1317653420-21404-3-git-send-email-mason@myri.com>
	 <CA+55aFyyx99Z4=x-Twp7JCpU=JHPzP8HRdLc4H3NOGHNQq9jCw@mail.gmail.com>
	 <1317742838.29415.217.camel@pasglop>
	 <CA+55aFzFWC3Acp0bwx33CgUZ9NgiDdJ8H=yNOdb0xmLsAAJZxQ@mail.gmail.com>
	 <1317744493.29415.238.camel@pasglop>
	 <CA+55aFyV9uqTt6UHA2wsAdRHHCSAtCSmoO2d3dm62HAo+s75Sg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 19:30:39 +0200
Message-ID: <1317749439.29415.251.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 09:51 -0700, Linus Torvalds wrote:
> On Tue, Oct 4, 2011 at 9:08 AM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> >>
> >> Well, bcrl argues that patches 1-2 of 3 are actively wrong.
> >
> > This is an argument that isn't finished :-)
> 
> Oh, I absolutely *hope* it isn't finished, but there's no way I'm
> applying a patch for -rc9 that people are still actively arguing
> whether it's at all valid or not.

Well, thing is, you -already- have the whole "performance" option which
is what we are 'arguing' about upstream. Except that the implementation
of it that you have in your tree now has very nasty bugs (ie it doesn't
do what it's supposed to and really doesn't work).

Patches 1 and 2 fix it to do what it's supposed to.

Whether that's a useful scheme or not is what Ben and I are discussing
and frankly the jury is still out as to whether it's beneficial or not
for the generic case. (It's basically an algorithm used today by pHyp on
power).

I wouldn't mind much if we just ripped it out, and left the other
options only at this stage.

> Which is why I'm planning on applying 3/3 just to make the whole issue
> irrelevant for 3.1, and then the people who want to test things out
> can apply whatever patches they want and play with the kernel command
> line options to actually enable whatever behavior they are testing.

As you like but I still think you should apply 1 and 2. As I said above,
the option is there already but the implementation is buggy. Let's at
least make it do what it's supposed to. It's still optional and will
still need testing and benchmarking but heh ...

Or the other option is to rip out all the "performance" case code.

I don't think it makes any sense to keep that option in it's current
non-working form. IE. The code right now does utterly wrong things and
generates something that cannot work if you chose that mode on your
kernel command line.

Cheers,
Ben.

