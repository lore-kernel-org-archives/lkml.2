Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247Ab0FJOP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:15:29 -0400
Received: from adelie.canonical.com ([91.189.90.139]:47570 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209Ab0FJOP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:15:28 -0400
Subject: Re: [PATCH 1/2] input: mt: Introduce MT event slots (rev 5)
From: Chase Douglas <chase.douglas@canonical.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
In-Reply-To: <1274567437-2818-1-git-send-email-rydberg@euromail.se>
References: <1274567437-2818-1-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jun 2010 10:15:19 -0400
Message-ID: <1276179319.24373.24.camel@cndougla-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-05-23 at 00:30 +0200, Henrik Rydberg wrote:
> With the rapidly increasing number of intelligent multi-contact and
> multi-user devices, the need to send digested, filtered information
> from a set of different sources within the same device is imminent.
> This patch adds the concept of slots to the MT protocol. The slots
> enumerate a set of identified sources, such that all MT events
> can be passed independently and selectively per identified source.
> 
> The protocol works like this: Instead of sending a SYN_MT_REPORT
> event immediately after the contact data, one sends an ABS_MT_SLOT
> event immediately before the contact data. The input core will only
> emit events for slots with modified MT events. It is assumed that
> the same slot is used for the duration of an initiated contact.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Revision 5 incorporates the following changes:
> 	 - Rename the slot event to ABS_MT_SLOT to keep all MT-related events
> 	   in the same namespace.
> 	 - Move the MT slot event list to input.h so that it can be read
> 	   by userspace.
> 
>  drivers/input/input.c |  105 +++++++++++++++++++++++++++++++++++++------------
>  include/linux/input.h |   44 ++++++++++++++++++++
>  2 files changed, 123 insertions(+), 26 deletions(-)

I was wondering what the status of this patch was. I reviewed it and I
think it's a good improvement of the protocol. I think it will help
simplify things in userspace event handling, and should reduce the noise
in evdev. I also like the incremental approach in that it doesn't force
drivers into the new protocol, but makes it available for them when they
can use it.

Acked-by: Chase Douglas <chase.douglas@canonical.com>

Long term, I think it makes the most sense to have a layer inside the
kernel to do software touch tracking and expose all MT data through the
slots protocol instead of it being determined by the capabilities of the
device/driver.

-- Chase

