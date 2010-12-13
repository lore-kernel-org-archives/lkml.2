Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab0LMVXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:23:39 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:51073 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755498Ab0LMVXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:23:37 -0500
Message-ID: <4D068E3C.8080100@euromail.se>
Date: Mon, 13 Dec 2010 22:21:00 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] input: mt: Interface and MT_TOOL documentation updates
References: <1292001842-5000-1-git-send-email-rydberg@euromail.se> <4D065BDE.5020107@canonical.com>
In-Reply-To: <4D065BDE.5020107@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PSFpO-0006Aa-Ba.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PSFpO-0006Aa-Ba 3636af15644aec10f588f79ba424fd46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 06:46 PM, Chase Douglas wrote:

> On 12/10/2010 09:24 AM, Henrik Rydberg wrote:
>> +- The MT_TOOL_ENVELOPE type is used to indicate that the contact position
>> +is not well-defined, and is only used for legacy hardware. The real contact
>> +positions are to be found within the bounding rectangle formed by the
>> +envelope contact positions.
> 
> By definition, this only covers rectangles with two coordinates to
> define the shape and location. Why do we want to call it envelope? It's
> just extra confusion to me. Why not call it MT_TOOL_RECT?


The envelope contacts serve as a way to detect a small area of fingers or a
large area of fingers. There is nothing inherently problematic with having one
or three or more such contacts.


> Please describe how to use this tool type. Its usage is different than
> any tool type usage before, so an explanation would be helpful. Must the
> value of the tool on the first touch be 0 until a second touch can
> define the rect? Or, can touches always default the value to 1 since
> we're talking about devices that only support two fingers?


For a dual-touch driver sending the lower-left and upper-right corners as
contacts, nothing really has to be done in user space. The contacts will look
weird in a drawing program, because the actual fingers and the ones on the
screen may diverge. The tool type indicates that this may be the case, so the
application can take measures if it wants to. This is the primary intended usage.

A driver can use MT_TOOL_ENVELOPE also for one finger.


> If this is really to remedy only poor two finger devices, would it be
> better to flag the device itself somehow to say "don't trust this
> device's coordinate positions" (or something more elegant)? This would
> prevent an extrapolation of tool types to multiple fingers at a time.


Maybe the device also has a pen, for which the coordinates should be trusted.


> Lastly, using tool types for this seems odd since this does not signify
> a physical tool. It merely signifies that the device coordinates cannot
> be trusted literally. Maybe we should use some other namespace for
> binding information across multiple touches, like MT_BIND_RECT?


The envelope coordinates can be trusted to yield a smoothly moving bounding
area, similar to tracked contacts. Completely untrusted contacts would first
have to be processed somewhere in order to be useful, which is less desirable.

Henrik
