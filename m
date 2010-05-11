Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab0EKTAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 15:00:09 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41790 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328Ab0EKTAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 15:00:00 -0400
Message-ID: <4BE9A911.1090203@cs.helsinki.fi>
Date: Tue, 11 May 2010 21:59:29 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mike Frysinger <vapier.adi@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       "=?ISO-8859-1?Q?Daniel_Gl=F6ckner?=" <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
References: <1273487642-2169-1-git-send-email-os@emlix.com> <1273488154-2993-1-git-send-email-os@emlix.com> <20100510142225.4bf215ef.akpm@linux-foundation.org> <20100511060547.GA9644@core.coreip.homeip.net> <AANLkTikA9s6lpO2uDuIup8BwGOYYHQ9yQxS36PBSIttX@mail.gmail.com> <20100511062110.GB9644@core.coreip.homeip.net> <AANLkTiktu7N5IXknkkJ9D5L4z5plhuGvD45IVqJm9zG1@mail.gmail.com> <20100511063309.GC9644@core.coreip.homeip.net> <y2k84144f021005102342m18bce930g53599c9112565f78@mail.gmail.com> <20100511165228.GC7396@core.coreip.homeip.net>
In-Reply-To: <20100511165228.GC7396@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> The architectures that we are trying to deal with here should be forcing
> kmalloc to the cache boundary already though - otherwise they would not
> be able to used kmalloced memory for DMA buffers at all. Or am I utterly
> lost here?

I don't know which architecture you're talking about but it's not true 
in general and you probably don't want to depend on it even if it 
happens to work now.
