Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934705Ab0KQMOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:14:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:38613 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934118Ab0KQMOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:14:34 -0500
Message-ID: <4CE3C6A7.1060508@kernel.org>
Date: Wed, 17 Nov 2010 13:12:23 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Kapil Arya <kapil@ccs.neu.edu>
CC: Gene Cooperman <gene@ccs.neu.edu>, Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org> <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com> <4CD26948.7050009@kernel.org> <20101104164401.GC10656@sundance.ccs.neu.edu> <4CD3CE29.2010105@kernel.org> <AANLkTimDXKsBCxbsEOfgkYV2R8FK=bhFdmx9UQow5hqp@mail.gmail.com> <4CE3B23D.6040603@kernel.org>
In-Reply-To: <4CE3B23D.6040603@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Nov 2010 12:12:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 11:45 AM, Tejun Heo wrote:
>> Since /proc/*/net provides a simpler design for sockets, we started
>> wondering what other simplifications may be possible. Here is one
>> possibility, in the case of shared file descriptors, DMTCP goes
>> through two barriers in order to decide which process will be
>> responsible for checkpointing which shared-file descriptor. It works
>> and the overhead is reasonable, but if you have additional
>> suggestion for this case, we would be very interested.
> 
> I wrote in another mail but you can find out which fd's are shared by
> flipping O_NONBLOCK and looking at the flags field of
> /proc/*/fdinfo/*.  Or are you talking about something else?

Ooh, one more thing, /proc/*/net/* has tx/rx queue counts.  With
those, you wouldn't need the cookie based connection draining, right?

Thanks.

-- 
tejun
