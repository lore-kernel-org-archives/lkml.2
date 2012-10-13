Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab2JMTdd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 15:33:33 -0400
Received: from mail.avalus.com ([89.16.176.221]:56709 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014Ab2JMTdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 15:33:32 -0400
Date: Sat, 13 Oct 2012 20:33:27 +0100
From: Alex Bligh <alex@alex.org.uk>
Reply-To: Alex Bligh <alex@alex.org.uk>
To: Hillf Danton <dhillf@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Alex Bligh <alex@alex.org.uk>
Subject: Re: Local DoS through write heavy I/O on CFQ & Deadline
Message-ID: <97166AE58C26A44D45569412@nimrod.local>
In-Reply-To: <CAJd=RBAdpGpSrx9e28MLmPAEhqRsCQGHNuc-sjUQPMTLO9agpQ@mail.gmail.com>
References: <0B138F62-16BF-4295-9AD9-64C0BB39FCE2@alex.org.uk>
 	<20121012133044.GA10115@dhcp22.suse.cz>
 	<E6EF14955C67D6CA58918872@nimrod.local>
 	<20121012145838.GD22083@dhcp22.suse.cz>
 	<3D1C85A52BB960B79E37AC30@nimrod.local>
 <CAJd=RBAdpGpSrx9e28MLmPAEhqRsCQGHNuc-sjUQPMTLO9agpQ@mail.gmail.com>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--On 13 October 2012 21:53:09 +0800 Hillf Danton <dhillf@gmail.com> wrote:

> Take a look at the "wait for writeback" problem please.
>
> 	Linux 3.0+ Disk performance problem - wrong pdflush behaviour
> 	https://lkml.org/lkml/2012/10/10/412

I'm guessing that's related but may not be the whole story. My
test case is rather simpler, and Viktor says that with the
patch causing his regression reverted, "After I've set the dirty_bytes
over the file size the writes are never blocked.". That suggests
to me that in order to avoid write blocking he needs dirty_bytes
larger than the file size. As the bytes written in my test case
exceed RAM, that's going to be be an issue as dirty_bytes is always
going to be hit; I think it Viktor's case he is trying to avoid
it being hit at all.

Or perhaps I have the wrong end of the stick.

-- 
Alex Bligh
