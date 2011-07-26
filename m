Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab1GZXRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 19:17:44 -0400
Received: from adelie.canonical.com ([91.189.90.139]:39586 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab1GZXRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 19:17:42 -0400
Message-ID: <4E2F4B11.3030402@canonical.com>
Date: Tue, 26 Jul 2011 16:17:37 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
CC: dmitry.torokhov@gmail.com, rydberg@euromail.se, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Subject: Re: [PATCH 9/9 v2] Input: synaptics - process finger (<=5) transitions
References: <1311169146-20066-1-git-send-email-djkurtz@chromium.org> <1311169146-20066-10-git-send-email-djkurtz@chromium.org> <4E2A1D9A.2090704@canonical.com> <CAGS+omABdrRjZ0nsajAB3WRj2WASUYKMfAaPeaOWuhUfLUFMeQ@mail.gmail.com>
In-Reply-To: <CAGS+omABdrRjZ0nsajAB3WRj2WASUYKMfAaPeaOWuhUfLUFMeQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2011 09:11 PM, Daniel Kurtz wrote:
> On Sat, Jul 23, 2011 at 9:02 AM, Chase Douglas
> <chase.douglas@canonical.com> wrote:
>>
>> On 07/20/2011 06:39 AM, djkurtz@chromium.org wrote:
>>> From: Daniel Kurtz <djkurtz@chromium.org>
>>>
>>> Synaptics image sensor touchpads track up to 5 fingers, but only report 2.
>>> They use a special "TYPE=2" (AGM-CONTACT) packet type that reports
>>> the number of tracked fingers and which finger is reported in the SGM
>>> and AGM packets.
>>>
>>> With this new packet type, it is possible to tell userspace when 4 or 5
>>> fingers are touching.
>>
>> Maybe I'm blind, but I don't see where the QUADTAP and QUINTAP values
>> are set in the events. I see where the bits are set during
>> initialization, but not during use.
> 
> It's subtle.
> The firmware actually report 4/5 in the AGM-CONTACT packet, which the
> agm packet parser sets directly in mt_state->count.
> This is then reported to userspace when synaptics_report_mt() calls
> input_mt_report_finger_count(dev, mt_state->count), which now supports
> QUINTTAP (see patch #8).

Ahh, thanks! Conditional upon getting the previous patches merged in
some fashion:

Acked-by: Chase Douglas <chase.douglas@canonical.com>
