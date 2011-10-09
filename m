Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab1JIWYR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 18:24:17 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:43399 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab1JIWYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 18:24:16 -0400
Subject: Re: [PATCH v8]: Improve performance of LZO/plain hibernation
From: Bojan Smojver <bojan@rexursive.com>
To: penberg@cs.helsinki.fi
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Date: Mon, 10 Oct 2011 09:24:14 +1100
In-Reply-To: <6127211897.1002662375@rexursive.com>
References: <1317342456.1959.6.camel@shrek.rexursive.com>
	 <3169978091.1002283638@rexursive.com> <201110062037.14322.rjw@sisk.pl>
	 <201110062045.48689.rjw@sisk.pl>
	 <CAOJsxLE7uRFv6FXsz+czLO3+VjDtT-QgHVRZEpZwBJJF0B3ahw@mail.gmail.com>
	 <6127211897.1002662375@rexursive.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1318199054.2004.1.camel@shrek.rexursive.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-09 at 21:19 +1100, Bojan Smojver wrote:
> May be related, when I simulate image loading failure by returning
> error from load_image(), I get bad page state error, count -1, so
> something is amiss. Probably the readahead buffers or maps. 

Yeah, this will probably be an easy fix. I think I've forgotten that
handle->cur is no longer being allocated as a standalone page on image
load (instead, it's a pointer into maps). So, when we fail, handle->cur
is freed twice, because it's not NULL. Will test the fix shortly.

-- 
Bojan

