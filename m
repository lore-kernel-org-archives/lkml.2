Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab0DHLlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 07:41:20 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:56033 "HELO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752324Ab0DHLlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 07:41:05 -0400
From: Michael Poole <mdpoole@troilus.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: introduce MT event slots
References: <1270685590-2204-1-git-send-email-rydberg@euromail.se>
	<87tyrmiqw2.fsf@troilus.org> <4BBDA555.1020003@euromail.se>
Date: Thu, 08 Apr 2010 07:40:59 -0400
In-Reply-To: <4BBDA555.1020003@euromail.se> (Henrik Rydberg's message of "Thu,
	08 Apr 2010 11:43:49 +0200")
Message-ID: <87mxxei33o.fsf@troilus.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrik Rydberg writes:

> Michael Poole wrote:
> [...]
>> 
>> How would the slot number for a contact be chosen?
>
> The device driver determines how to use the slots. The driver calls
> input_mt_slot(dev, slot), sends the data for the slot, picks another slot, and
> repeats.
>
>> If the kernel makes
>> that assignment, what should a "slot" correspond to from a computer
>> user's perspective? "Set[s] of identified sources" is a little vague:
>> Does it mean contacts from one hand, contacts in one displayed window
>> (assuming the touch surface is a screen), or something else?  (I assume
>> it would not duplicate the blob or tracking IDs already defined for MT
>> events.)
>
> The slot is only used for data communication. Think of the slot as a combined,
> unique identifier. For example, imagine a device driver dealing with contacts
> labeled with both a USER_ID and a TRACKING_ID. The driver assigns every active
> (USER_ID, TRACKING_ID) contact to a specific slot, and uses it to communicate
> all changes to that contact. When the contact is destroyed (for instance by
> sending a zero ABS_MT_PRESSURE on that slot), the slot is free to be used for
> another contact.

For hardware with touch tracking support, what does a slot ID provide
for user-space that the tracking ID doesn't?  (TRACKING_ID is already
supposed to be unique for the life of the touch.)  For hardware without
touch tracking, is the driver expected to implement the Euclidean
bipartite matching in order to assign touch reports to slots?

(Pardon me if I'm being dense -- I'm more familiar with the kernel
driver side, not the X server's implementation or dispatch of multitouch
events.)

Michael Poole
