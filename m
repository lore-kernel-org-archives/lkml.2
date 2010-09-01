Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab0IANTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 09:19:45 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:40472 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752572Ab0IANTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 09:19:42 -0400
Message-ID: <4C7E51AA.2050004@euromail.se>
Date: Wed, 01 Sep 2010 15:14:18 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100820 Thunderbird/3.1.2
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: Jiri Kosina <jkosina@suse.cz>, Michael Poole <mdpoole@troilus.org>,
        Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7 v3] HID: magicmouse: simplify multitouch feature request
References: <1283306184-28833-1-git-send-email-chase.douglas@canonical.com>	 <1283306184-28833-3-git-send-email-chase.douglas@canonical.com>	 <4C7E0433.8010008@euromail.se> <1283344475.2255.368.camel@mini>
In-Reply-To: <1283344475.2255.368.camel@mini>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1Oqn8w-0002pX-4h.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Oqn8w-0002pX-4h baa55dbed0de0565ba0de5e2b0967f81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2010 02:34 PM, Chase Douglas wrote:

> On Wed, 2010-09-01 at 09:43 +0200, Henrik Rydberg wrote:
>> On 09/01/2010 03:56 AM, Chase Douglas wrote:
>>
>>> From: Chase Douglas <chase.douglas@ubuntu.com>
>>>
>>> Only the first feature request is required to put the Magic Mouse into
>>> multitouch mode. This is also the case for the Magic Trackpad, for which
>>> support will be added in a later commit.
>>>
>>> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
>>> Acked-by: Michael Poole <mdpoole@troilus.org>
>>> ---
>>
>>
>> Since this is starting to look awfully similar to the mode switch found in
>> appletouch and bcm5974, I wonder what happens to the stream from the device when
>> the connection to hid is closed. It could be that the mode switch should be
>> moved to open/close instead.
> 
> I don't really understand what you are proposing. It sounds like maybe
> you want the device to continue to function in a non-multitouch way
> after hid disconnection, but the device needs hid to function at all.


Suspend/resume, broken bt connections, etc. There was an issue with the bcm5974
macbook trackpads not functioning properly after a close unless returned to
normal mode. The mode switch code was moved to the open/close functions for that
reason.


> The closest thing I can think to what you are saying is to do whatever
> it takes on module removal so that it goes back to functioning in the
> non-multitouch mode. That may be possible.


Sounds like a good start. Doing a suspend test just now I could not get the
device up again, for whatever reason.

Henrik
