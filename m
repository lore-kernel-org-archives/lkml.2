Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab0LFQl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:41:56 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54681 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab0LFQly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:41:54 -0500
Date: Mon, 6 Dec 2010 17:41:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, "Ted Ts'o" <tytso@mit.edu>,
        David Sharp <dhsharp@google.com>, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, mrubin@google.com
Subject: Re: [Patch 00/15] Reduce tracing payload size.
Message-ID: <20101206164150.GD24977@basil.fritz.box>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
 <878w03t4sn.fsf@basil.nowhere.org>
 <20101206135637.GC8135@thunk.org>
 <20101206145852.GA24977@basil.fritz.box>
 <AANLkTin9=zCbfwdt0GxaGMynTqUsf8R4GWJy88qw87A_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin9=zCbfwdt0GxaGMynTqUsf8R4GWJy88qw87A_@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That is true for the decompression step but not for the compression
> one, which takes more than 10 memcpys().

That's a good point. At 10x it's definitely too slow. Too bad, would have been too easy.

I guess one could still consider some very cheap data specific delta compressions 
(I assume there's a lot of redundancy in a tracing stream with similar events
occurring in a row or nearby) I used this technique successfully with large log files 
in the past and overall moving less data around ends up being cheaper.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
