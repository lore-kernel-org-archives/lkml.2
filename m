Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab1GESUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 14:20:03 -0400
Received: from adelie.canonical.com ([91.189.90.139]:58889 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab1GESUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 14:20:01 -0400
Message-ID: <4E1355CB.9070504@canonical.com>
Date: Tue, 05 Jul 2011 11:19:55 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Daniel Kurtz <djkurtz@chromium.org>, dmitry.torokhov@gmail.com,
        rubini@cvml.unipv.it, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, derek.foreman@collabora.co.uk,
        daniel.stone@collabora.co.uk, olofj@chromium.org
Subject: Re: [PATCH 05/12] Input: synaptics - process button bits in AGM packets
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org> <1309324042-22943-6-git-send-email-djkurtz@chromium.org> <20110704212404.GC23915@polaris.bitmath.org> <CAGS+omALkYhzS+rvWhsXCwuWMHWpJJJ7j9Z9cBQ1Gem5HnH_fg@mail.gmail.com> <20110705181843.GA29296@polaris.bitmath.org>
In-Reply-To: <20110705181843.GA29296@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2011 11:18 AM, Henrik Rydberg wrote:
>>> Any particular reason to move these and leave them unassigned for clickpads?
>>
>> Yes.  The current implementation incorrectly parses the x, y, z of AGM
>> packets and assigns junk values to the corresponding fields of the
>> temporary hw struct.  Luckily, this struct is then just discarded upon
>> return (synaptics_parse_hw_state returns 1 causing
>> synaptics_process_packet() to exit immediately).
>>
>> Instead, this patch parses the w value first to determine the packet
>> type, and then use this packet type information to parse the remaining
>> position and pressure fields correctly...
>>
>> Notice that the "else" clause is taken for SGM packets (w != 2), even
>> for clickpads.
> 
> Functionally, there is no difference between assigning new junk or
> reusing old junk, hence that part of the patch is not strictly needed.

True, it's not necessary, but I do like the new flow better. I was
reviewing the patch myself when I started wondering why we ever assigned
junk that was incorrect. I think this will help clean up the code and
make it more readable.

-- Chase
