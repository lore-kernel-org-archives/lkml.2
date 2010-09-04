Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab0IDRWG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 13:22:06 -0400
Received: from 1wt.eu ([62.212.114.60]:43467 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414Ab0IDRWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 13:22:04 -0400
Date: Sat, 4 Sep 2010 19:22:01 +0200
From: Willy Tarreau <w@1wt.eu>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
Message-ID: <20100904172201.GM25062@1wt.eu>
References: <201009041842.19968.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009041842.19968.Martin@lichtvoll.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

On Sat, Sep 04, 2010 at 06:42:19PM +0200, Martin Steigerwald wrote:
(...)
> The main idea here is to have a two-staged freeze process and to 
> distribute the "I am only taking bug fixes" work to more people than Linus.
> 
> For this to work properly, I think at the time of the release of the 
> stable kernel subsystem maintainers and Andrew should branch their trees. 
> For example when 2.6.36 is released:
> 
> - tree 
>   => 2.6.36-stable-tree
>   => tree, where 2.6.37 stuff will be going in
> 
> Thus when subsystem maintainers take new stuff during the merge window, it 
> will be for the next kernel release already, not for the current one. 
> Except bugfix work. Whereas I think the criteria for bug fix work should not 
> be that strict than for the stable patches Greg collects.
> 
> Thus it needs to be clear: No new stuff for next kernel already two weeks 
> prior to release the current stable kernel.

While I respect your beliefs on this matter (they once were mine too), I now
realized I was wrong for several reasons :
  - most developers want to create. They (generally) test what they create,
    they believe it's flawless because it works for them. No need for more
    testing, go on with new features ; if you refuse to merge their new work
    for some time, they work on their own tree and push you more work at once
    next time.

  - developers need real world use cases. That means more testers. Developers
    are bad testers because they don't trigger the unexpected use cases. And
    how do you get good testers ? by motivating end users to test your code.
    Most testers will only test a new kernel to get a new feature. If it works
    for them, no need to push the tests further. So that means that the first
    RCs are the most tested, and that the later ones are the least tested.
    Thus at one point you can't hope to get bug reports anymore. When you see
    an -rc7 or -rc8, you think "hey, -rc4 was OK, let's wait for -final and
    install it".

  - people concerned by stability don't test every release. They test when
    they can, precisely because they can't impact production. So they don't
    contribute bug reports in time. And as the 2.4 maintainer, I'm well
    aware of that, because when I break something, I only know about it 3-4
    months later.

For this reason, I think the release rhythm can't much be changed. I think
that trying to evaluate and publish quality per developer or maintainer can
have a better effect because everyone in the commit chain is responsible.
But even doing that is hard because some changes touch everything and it's
not obvious to say that Mr X or Y has done some crap.

In my opinion, reporting bugs is the most effective way of improving
quality. If you report 10 bugs in a week on the same driver, there are
chances that at one point this driver's author will want to take some
time to audit his code and find other bugs before you next point your
finger at him/her. As you see, the goal is not just to report bugs to
get them fixed, but to educate bug authors.

I can tell you that I am an author of quite a number of bugs in another
project (haproxy), and I absolutely hate it when a bug is detected in
production (especially given the product's goal), to the point that the
code is generally reworked 2, 3, 5, 10 times before being committed. Of
course it is still not enough to catch all bugs, but since the product
has got a widely accepted reputation of being rock solid, I think it
works quite well afterall.

Last, developers must not betray their users' trust. When they're not
certain of their code, this must be advertised (this is often the case
but not always). That helps a lot end users select only reliable features
and experience more stability.

Regards,
Willy

