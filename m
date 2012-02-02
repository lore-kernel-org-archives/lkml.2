Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab2BBMjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:39:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57467 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab2BBMjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:39:53 -0500
Date: Thu, 2 Feb 2012 13:39:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] selftests: Make run_tests executable
Message-ID: <20120202123947.GA9071@somewhere.redhat.com>
References: <1327943069-28048-1-git-send-email-fweisbec@gmail.com>
 <20120130155105.029b02fb.akpm@linux-foundation.org>
 <20120201152447.GC6731@somewhere.redhat.com>
 <20120201115403.d140742e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120201115403.d140742e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 11:54:03AM -0800, Andrew Morton wrote:
> On Wed, 1 Feb 2012 16:24:53 +0100
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Mon, Jan 30, 2012 at 03:51:05PM -0800, Andrew Morton wrote:
> > > On Mon, 30 Jan 2012 18:04:29 +0100
> > > Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > 
> > > > Make the main script that launches the tests to
> > > > become executable. Otherwise people need to launch
> > > > it as an argument to a new bash instance.
> > > > 
> > > 
> > > That's a feature ;)
> > > 
> > > The x bit can easily get lost on kernel scripts.  For example, if
> > > someone upgrades their kernel with patch(1) and the patch adds or
> > > renames the script, the x bit gets lost.
> > > 
> > > If we were to set the x bit for the subset of people who get their
> > > scripts direct from a git repository then those people might write and
> > > distribute tools which fail when used by people who have lost their x
> > > bit.  I've seen this happen at least once before.
> > > 
> > 
> > I see. Another way could be to chmod the run_test script from the Makefile.
> > Would that sound clumsy?
> 
> I suggest we remove the script and make it a makefile target instead. 
> "make tests" or whatever.  As a microbonus that would remove the need
> to duplicate the TARGETS definition in the two scripts.

Sounds good. But we still need the TARGET in the makefile to list the
directories. Although I can do a simple ls.
