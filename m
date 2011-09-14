Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab1INTf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 15:35:26 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:61072 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932890Ab1INTfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 15:35:23 -0400
X-AuditID: 12074425-b7bf1ae000000a2a-68-4e7101c04bd4
Message-ID: <4E7101F3.1090204@mit.edu>
Date: Wed, 14 Sep 2011 12:35:15 -0700
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Junio C Hamano <gitster@pobox.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, git@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Survey] Signed push
References: <7vaaa8xufi.fsf@alter.siamese.dyndns.org>
In-Reply-To: <7vaaa8xufi.fsf@alter.siamese.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42IRYrdT0T3AWOhn8POUiUXXlW4mi4beK8wW
	l3fNYbN41PeW3YHF48SM3yweFy8pe3zeJBfAHMVlk5Kak1mWWqRvl8CVceqZVEEnb8XNdYvZ
	Gxg3cHUxcnJICJhIfJn9iwXCFpO4cG89G4gtJLCPUeLTz7ouRi4gewOjxPF/jcwQzkYmiVf7
	+sCqeAXUJC79bWUCsVkEVCVmvvrKCGKzCahIdCx9ABYXFQiTODXvDjNEvaDEyZlPwLaJAPVO
	bDsEZjML5Emc+LQZrEZYQFHizqKNzBBXmErM3nEXaA4HB6eAmcTD17wQ5ToS7/oeMEPY8hLb
	385hnsAoOAvJhllIymYhKVvAyLyKUTYlt0o3NzEzpzg1Wbc4OTEvL7VI10IvN7NELzWldBMj
	OKxdVHcwTjikdIhRgINRiYc34nuBnxBrYllxZe4hRkkOJiVRXmNgVAjxJeWnVGYkFmfEF5Xm
	pBYfYpTgYFYS4RV6DVTOm5JYWZValA+TkuZgURLnfb3DwU9IID2xJDU7NbUgtQgmK8PBoSTB
	mwEyVLAoNT21Ii0zpwQhzcTBCTKcB2h4LkgNb3FBYm5xZjpE/hSjLse3qbeOMwqx5OXnpUqJ
	89qBFAmAFGWU5sHNgaWjV4ziQG8J86aAVPEAUxncpFdAS5iAlijPBvmguCQRISXVwOhW7x1k
	kflqiZvVcifOa1dOhl8/eCLChsmq9nPrmhJXoRSuDXMSV7J8ExbUuVy42UZYxLs8Op/9wceH
	Ig9qTfb/lX/89d/j+Qsrgheo/nz8/vffxTcuGPx888Fu7x+FY3r50ZG/z989Fxf6zqYx/2lc
	n/vyO9cUXvwRb57HafIoyT6m8GCa2SUlluKMREMt5qLiRACQ3N4XIgMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2011 09:45 AM, Junio C Hamano wrote:
> 
> An alternative that I am considering is to let the requester say this
> instead:
> 
>     are available in the git repository at:
>       git://git.kernel.org/pub/flobar.git/ 5738c9c21e53356ab5020912116e7f82fd2d428f
> 
> without adding the extra line.
> 
> That is, to allow fetching the history up to an explicitly named commit
> object. This would only involve a change to fetch-pack at the receiving
> end; just match the commit object name given from the command line against
> the ls-remote response and ask upload-pack to give the history leading to
> it. The released versions of Git already will happily oblige, as long as
> the commit object named in the request message still sits at the tip of
> the intended branch.

I would love this feature on the pull/fetch interface, but for a
completely different reason.  Sometimes I want to pull a particular
object (usually a commit, but sometimes just a tree or blob) from
*myself*, and having to stick it on a branch is annoying.

One use-case is when applying a patch in git's extended format.  If I
know where it came from, I ought to be able to pull the blobs it depends
on to enable three-way merge.  I think that this is essentially
impossible remotely right now.

Of course, merging with the result of the pull will result in terrible
automatically-generated messages, but it's easy to fix that up manually.

This is one thing that I think Mercurial handles better than git.  (And
apologies for the noise if I've missed a way to do this with current
git.  I've looked, but maybe I missed some magic way to do this.)

--Andy
