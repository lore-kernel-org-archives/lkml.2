Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab2HTSay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:30:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41041 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2HTSav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:30:51 -0400
Message-ID: <50328258.9030800@wwwdotorg.org>
Date: Mon, 20 Aug 2012 12:30:48 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Drewry <wad@chromium.org>,
        "cross-distro@lists.linaro.org" <cross-distro@lists.linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: root=PARTUUID for MBR/NT disk signatures?
References: <502EC16C.4030007@wwwdotorg.org> <20120820182254.GQ24861@google.com>
In-Reply-To: <20120820182254.GQ24861@google.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 12:22 PM, Tejun Heo wrote:
> Hello,
> 
> On Fri, Aug 17, 2012 at 04:10:52PM -0600, Stephen Warren wrote:
>> I was considering extending the kernel command-line option
>> root=PARTUUID= to also support MBR (NT disk signatures). I was thinking
>> of a syntax along the lines of:
>>
>> root=PARTUUID=UUUUUUUU-PP[/PARTNROFF=%d]
>>
>> ... where UUUUUUUU is the hex representation of the NT disk signature,
>> and PP is the hex representation of the partition number. Like GPT,
>> /PARTNROFF could be used too if desired.
>>
>> Related, I was thinking of changing struct partition_meta_info's uuid
>> field to be a string, so that it could simply be strcmp'd against the
>> UUID value on the kernel command-line. That way, the type of the UUID is
>> irrelevant.
>>
>> Does anyone have any objection to that?
> 
> Wouldn't that be able to break setups which work currently?

I don't believe so:

Since the newly supported UUID syntax wouldn't ever match any EFI UUID
(the lengths differ in all cases), I don't believe the new syntax would
affect behavior for any existing usage.

Obviously, part_efi.c would be modified to initialize struct
partition_meta_info's uuid field to the appropriate string
representation of the UUID so that the str(case)cmp would still succeed
for existing command-lines. I ended up coding up that part of the change
late Friday, and the feature was certainly still working OK.
