Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab0DPHkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 03:40:41 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:6380 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab0DPHkj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 03:40:39 -0400
X-IronPort-AV: E=Sophos;i="4.52,218,1270440000"; 
   d="scan'208";a="15461893"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Henrik Rydberg <rydberg@euromail.se>, Michael Poole <mdpoole@troilus.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 16 Apr 2010 08:40:37 +0100
Subject: RE: [PATCH] input: mt: introduce MT event slots
Thread-Topic: [PATCH] input: mt: introduce MT event slots
Thread-Index: AcrXG/fCnJN91msPQB+Jbx5aGuYeBwGG0PaQ
Message-ID: <544AC56F16B56944AEC3BD4E3D5917712E567F0FEB@LIMKCMBX1.ad.analog.com>
References: <1270685590-2204-1-git-send-email-rydberg@euromail.se>
	<87tyrmiqw2.fsf@troilus.org> <4BBDA555.1020003@euromail.se>
 <87mxxei33o.fsf@troilus.org> <4BBDD3B1.6030808@euromail.se>
In-Reply-To: <4BBDD3B1.6030808@euromail.se>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrik Rydberg wrote on 2010-04-08:
> Michael Poole wrote:
> [...]
>>
>> For hardware with touch tracking support, what does a slot ID
>> provide for user-space that the tracking ID doesn't?  (TRACKING_ID
>> is already supposed to be unique for the life of the touch.)
>
> The purpose of the slot is twofold. Firstly, it reintroduces the
> ability for the kernel to filter ABS_MT events, which reduces the
> number of events emitted from the input core by a large factor.
> Secondly, it allows the driver to send partial information without
> breaking the protocol.
>
> The current MT protocol is designed for anonymous contacts, which
> dictates that all data for all fingers has to be sent between every
> synchronization point.
> Although this is fine for a handful of fingers, it does not play well
> with a larger scenario. The slot concept allows for a minimum of
> information to be emitted from the input core, without breaking
> compatibility with the current MT protocol. If a single attribute of a
> single finger of a single user is changed, the event sequence will
> simply be:
>
> SYN_MT_SLOT <slot-in-use>
> ABS_MT_ATTRIBUTE <some-value>
>
> If the contact gets destroyed and replaced by another one, there is
> not even a need to send that information explicitly, but this sequence
> would suffice:
>
> SYN_MT_SLOT <slot-in-use>
> ABS_MT_USER_ID <replacing-user>
> ABS_MT_TRACKING_ID <replacing-tracking-id>
> ABS_MT_ATTRIBUTE1 <some-value>
> ABS_MT_ATTRIBUTE2 <some-value>
> ...

Sorry, I must have missed something -
What is ABS_MT_USER_ID?

Regards,
Michael

Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 4036 Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif


