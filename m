Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab0KIVms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:42:48 -0500
Received: from threatwall.zlynx.org ([64.81.105.251]:32774 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754770Ab0KIVmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:42:44 -0500
X-Greylist: delayed 1248 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Nov 2010 16:42:44 EST
Message-ID: <4CD9BB5B.2090206@acm.org>
Date: Tue, 09 Nov 2010 14:21:31 -0700
From: Zan Lynx <zlynx@acm.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, esandeen@redhat.com, jmoyer@redhat.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] clear PageError bit in msync & fsync
References: <20101109114422.3918e7f6@annuminas.surriel.com> <20101109142109.224267d0@corrin.poochiereds.net> <4CD9A209.6070807@redhat.com>
In-Reply-To: <4CD9A209.6070807@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20101109/1PFvdG-0000a0-Uc-linux-kernel@vger.kernel.org:zlynx@acm.org:64.81.105.251
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/9/10 12:33 PM, Rik van Riel wrote:
> On 11/09/2010 02:21 PM, Jeff Layton wrote:
>
>> This does leave the page in sort of a funky state. The uptodate bit
>> will still probably be set, but the dirty bit won't be. The page will
>> be effectively "disconnected" from the backing store until someone
>> writes to it.
>>
>> I suppose though that this is the best that can reasonably be done in
>> this situation however...
>
> I spent a few days looking for alternatives, and indeed I found
> nothing better...

Just an off the top of my head crazy idea...

Could you leave the error bit set on the page and treat it as a dirty 
bit during a future msync, clearing the error bit at that point.

The general idea would be to leave the error set unless an explicit 
write was requested.

-- 
Zan Lynx
zlynx@acm.org

"Knowledge is Power.  Power Corrupts.  Study Hard.  Be Evil."
