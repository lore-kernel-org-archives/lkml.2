Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab0DESrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 14:47:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35668 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543Ab0DESrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 14:47:19 -0400
Message-ID: <4BBA3021.9090504@zytor.com>
Date: Mon, 05 Apr 2010 11:46:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: guenter.roeck@ericsson.com
CC: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi, mingo@redhat.com,
       x86@kernel.org
Subject: Re: [PATCH][RESEND] x86: Do not write to VGA memory space if CONFIG_VGA_CONSOLE
 is undefined
References: <1270046479-4486-1-git-send-email-guenter.roeck@ericsson.com>	 <84144f021003310832i3420e4c1g7396b4d1f311f393@mail.gmail.com> <1270491029.1477.453.camel@groeck-laptop>
In-Reply-To: <1270491029.1477.453.camel@groeck-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2010 11:10 AM, Guenter Roeck wrote:
> On Wed, 2010-03-31 at 11:32 -0400, Pekka Enberg wrote:
>> On Wed, Mar 31, 2010 at 4:41 PM, Guenter Roeck
>> <guenter.roeck@ericsson.com> wrote:
>>> Current early_printk code writes into VGA memory space even
>>> if CONFIG_VGA_CONSOLE is undefined. This can cause problems
>>> if there is no VGA device in the system, especially if the memory
>>> is used by another device.
>>>
>>> Fix problem by redirecting output to early_serial_console
>>> if CONFIG_VGA_CONSOLE is undefined.
>>>
>>> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
>>
>> Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
>>
> What will it take to get this patch into the tree ?
> 
> If there are coding style issues or some other unresolved concerns,
> please let me know.
> 

You didn't answer my question (c).

I want to know how you ended up with
boot_params.screen_info.orig_video_isVGA == 1 on a system with no VGA,
which seems like it would have resolved this.

I am *not* inclined to add a compile-time test for what should have been
handed with a runtime test already.

	-hpa

