Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab2DYPYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:24:52 -0400
Received: from longford.logfs.org ([213.229.74.203]:45068 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab2DYPYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:24:51 -0400
Date: Wed, 25 Apr 2012 09:25:14 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] add blockconsole
Message-ID: <20120425132513.GA23492@logfs.org>
References: <20120424205946.GH20610@logfs.org>
 <x49zka0j5bk.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <x49zka0j5bk.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 April 2012 09:42:39 -0400, Jeff Moyer wrote:
> 
> Neat idea, but I'm curious to know how it works when the system panics
> and you no longer can schedule the writeback thread.  What are the
> limitations you've seen in practice?

If the writeback thread doesn't get scheduled, you lose that
information.  Formerly I did the submit_bio directly, but lockdep
reminded me that I shouldn't do so from interrupt context.  Bummer.

Also, this is pretty young code so far.  We are starting to deploy it
in numbers just about now.  The obvious hope is that it will record a
non-zero class of problems that doesn't make it to syslog.  And the
obvious fear is that it will fail to record another non-zero class of
problems.  As to the extend of those two classes, we just don't have
good data yet.

But as they say, release early, release often, and hope some reviewer
finds a bug you can fix before having to debug it the hard way. ;)

Jörn
