Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab1GKNvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:51:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757316Ab1GKNvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:51:01 -0400
Subject: Re: Union mount and lockdep design issues
From: Ian Kent <ikent@redhat.com>
To: Michal Suchanek <hramrach@centrum.cz>
Cc: Peter Zijlstra <peterz@infradead.org>, David Howells <dhowells@redhat.com>,
        Ric Wheeler <rwheeler@redhat.com>, Alexander Viro <aviro@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, miklos@szeredi.hu
In-Reply-To: <CAOMqctQoO7zKojoEuYri8ZWDDMM3Ef6VRtPYzsf-02xhJ8e6jA@mail.gmail.com>
References: <1310305703.13309.7.camel@twins> <4E0AF2BA.2040706@gmail.com>
	 <1302756608.2854.10.camel@perseus.themaw.net>
	 <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
	 <4DA4B6A8.7030804@gmail.com>
	 <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
	 <4DA5DCB8.3040101@gmail.com>
	 <BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com>
	 <4DA5F569.9020309@gmail.com>
	 <BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com>
	 <24792.1302808448@redhat.com> <2477.1309342656@redhat.com>
	 <4E1962BE.8010204@redhat.com> <1408.1310382069@redhat.com>
	 <1310385651.18678.59.camel@twins>
	 <CAOMqctQoO7zKojoEuYri8ZWDDMM3Ef6VRtPYzsf-02xhJ8e6jA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 21:50:32 +0800
Message-ID: <1310392232.4276.14.camel@perseus.themaw.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-11 at 15:36 +0200, Michal Suchanek wrote:
> On 11 July 2011 14:00, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2011-07-11 at 12:01 +0100, David Howells wrote:
> >> Peter Zijlstra <peterz@infradead.org> wrote:
> >>
> 
> >> > Also, why would you want to have a class per sb-instance? From last
> >> > talking to David, he said there could only ever be 2 filesystems
> >> > involved in this, the top and bottom, and it is determined on (union)
> >> > mount time which is which.
> >>
> >> There can be more than 2 - one upperfs (the actual union) and many lowerfs -
> >> though I think only one lowerfs is accessed at a time.
> >
> > Right, however I understood from our earlier discussion that the vfs
> > would only ever try to lock 2 filesystems at a time, the top and one
> > lower.
> 
> This is true from local point of view. However, it is technically
> possible to use overlayfs as the upper layer of another overlayfs
> which allows layering multiple readonly "branches" into a single
> overlay. Since the vfs will lock the "union" and one (or possibly
> both) of its branches and one of the branches may be itself an union
> you can get arbitrary depth (which is currently limited by a constant
> in the code to cut recursion depth and stack usage).

Off topic but can you elaborate on that?

Are you saying the "unioned stack" can consist of more than two file
systems and can have more than two layers and possibly a mix of multiple
read-only and read-write file systems?

Ian


