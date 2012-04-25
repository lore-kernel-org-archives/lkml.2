Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab2DYQ02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:26:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756153Ab2DYQ0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:26:24 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: =?utf-8?Q?J=C3=B6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] add blockconsole
References: <20120424205946.GH20610@logfs.org>
	<x49zka0j5bk.fsf@segfault.boston.devel.redhat.com>
	<20120425132513.GA23492@logfs.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 25 Apr 2012 11:52:28 -0400
In-Reply-To: <20120425132513.GA23492@logfs.org> (=?utf-8?Q?=22J=C3=B6rn?=
 Engel"'s message of
	"Wed, 25 Apr 2012 09:25:14 -0400")
Message-ID: <x49vcknkdvn.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel <joern@logfs.org> writes:

> On Wed, 25 April 2012 09:42:39 -0400, Jeff Moyer wrote:
>> 
>> Neat idea, but I'm curious to know how it works when the system panics
>> and you no longer can schedule the writeback thread.  What are the
>> limitations you've seen in practice?
>
> If the writeback thread doesn't get scheduled, you lose that
> information.  Formerly I did the submit_bio directly, but lockdep
> reminded me that I shouldn't do so from interrupt context.  Bummer.

Well, submit_bio can sleep, obviously.  Perhaps you could explore
registering a panic notifier, and then flush the logs from there?
Unfortunately, there is always the possibility that some required locks
will be taken, but it might get you a little bit further.  Or, you could
explore the route that the diskdump or lkcd folks took, implementing
their own polling mode drivers.

Cheers,
Jeff
