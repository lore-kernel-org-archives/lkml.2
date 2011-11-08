Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab1KHBdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:33:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47376 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab1KHBdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:33:44 -0500
Message-ID: <4EB886E2.1000504@zytor.com>
Date: Mon, 07 Nov 2011 17:33:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Bryan Freed <bfreed@chromium.org>
CC: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, msb@chromium.org, marco.stornelli@gmail.com,
        seiji.aguchi@hds.com, tony.luck@intel.com
Subject: Re: [PATCH] ramoops: Add a device file for ramoops buffer access.
References: <1320710760-2734-1-git-send-email-bfreed@chromium.org> <20111108003622.GM21663@outflux.net> <CAEYUcX3wKfQZGFbRuRHgE8wuc_=Jm+-9s68tb20jkd_yqRHOjA@mail.gmail.com>
In-Reply-To: <CAEYUcX3wKfQZGFbRuRHgE8wuc_=Jm+-9s68tb20jkd_yqRHOjA@mail.gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I mentioned to Kees on IRC, you probably want to talk to Tony Luck
about his pstore interface, too.

On 11/07/2011 05:04 PM, Bryan Freed wrote:
> Yeah, we should definitely work together on this.
> 
> bryan.
> 
> On Mon, Nov 7, 2011 at 4:36 PM, Kees Cook <keescook@chromium.org> wrote:
>> Hi Bryan,
>>
>> On Mon, Nov 07, 2011 at 04:06:00PM -0800, Bryan Freed wrote:
>>> Add a /dev/ramoops device file that gives direct access to ramoops buffers.
>>> This interface is cleaner than using /dev/mem to access the buffers because
>>> we no longer need to lseek() or (for ARM) mmap() to an address specified in
>>> the sysfs mem_address file.
>>
>> This looks pretty good, except that I'd also want to remove all the module
>> parameters since this would bypass CONFIG_STRICT_DEVMEM (imagine a
>> malicious root user loading this module to spy on RAM via the new
>> interface).
>>
>> Last week I actually wrote an entire seq_file interface for ramoops[1], but
>> it seems it shouldn't live in /proc, so it needs to be reworked a bit to
>> live in /dev, as you have it.
>>
>> Perhaps we could merge our efforts?
>>
>> -Kees
>>
>> [1] https://gerrit.chromium.org/gerrit/#change,11242
>>
>> --
>> Kees Cook
>> ChromeOS Security
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

