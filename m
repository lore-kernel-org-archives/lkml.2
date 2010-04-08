Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab0DHJoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 05:44:09 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:34957 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756764Ab0DHJoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 05:44:05 -0400
Message-ID: <4BBDA555.1020003@euromail.se>
Date: Thu, 08 Apr 2010 11:43:49 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Michael Poole <mdpoole@troilus.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: introduce MT event slots
References: <1270685590-2204-1-git-send-email-rydberg@euromail.se> <87tyrmiqw2.fsf@troilus.org>
In-Reply-To: <87tyrmiqw2.fsf@troilus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.129.72
X-Scan-Result: No virus found in message 1NzoH9-00016z-4x.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1NzoH9-00016z-4x c8a7e94744fc84b661c01ea449c4dd88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Poole wrote:
[...]
> 
> How would the slot number for a contact be chosen?

The device driver determines how to use the slots. The driver calls
input_mt_slot(dev, slot), sends the data for the slot, picks another slot, and
repeats.

> If the kernel makes
> that assignment, what should a "slot" correspond to from a computer
> user's perspective? "Set[s] of identified sources" is a little vague:
> Does it mean contacts from one hand, contacts in one displayed window
> (assuming the touch surface is a screen), or something else?  (I assume
> it would not duplicate the blob or tracking IDs already defined for MT
> events.)

The slot is only used for data communication. Think of the slot as a combined,
unique identifier. For example, imagine a device driver dealing with contacts
labeled with both a USER_ID and a TRACKING_ID. The driver assigns every active
(USER_ID, TRACKING_ID) contact to a specific slot, and uses it to communicate
all changes to that contact. When the contact is destroyed (for instance by
sending a zero ABS_MT_PRESSURE on that slot), the slot is free to be used for
another contact.

> It seems like those would be important aspects of the protocol
> to document in Documentation/input/multi-touch-protocol.txt --
> otherwise, driver implementers or application developers might get it
> wrong.

Certainly.

Cheers,
Henrik

