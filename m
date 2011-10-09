Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab1JIHyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 03:54:21 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:51640 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab1JIHyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 03:54:21 -0400
Subject: Re: [PATCH v8]: Improve performance of LZO/plain hibernation
From: Bojan Smojver <bojan@rexursive.com>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Date: Sun, 09 Oct 2011 18:54:19 +1100
In-Reply-To: <9904162235.1002635820@rexursive.com>
References: <1317342456.1959.6.camel@shrek.rexursive.com>
	 <3169978091.1002283638@rexursive.com> <201110062037.14322.rjw@sisk.pl>
	 <201110062045.48689.rjw@sisk.pl> <9904162235.1002635820@rexursive.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1318146859.1916.4.camel@shrek.rexursive.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-09 at 13:57 +1100, Bojan Smojver wrote:
> My CRC32 checks keep failing on resume. 
> I don't get a panic, but still, this should not happen. 

False alarm, actually. My threaded CRC32 code was broken and was not
taking some of the last pages into account. I fixed that now in my code
and indeed CRC32 of the decompressed pages is the same as the one of the
pages before compression.

PS. We are going to lose about 10% of the the speed improvements by
introduction of CRC32 (which will only be used with compression). I
reckon it's still worth it.

-- 
Bojan

