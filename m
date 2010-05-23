Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab0EWRYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 13:24:18 -0400
Received: from xenotime.net ([72.52.115.56]:57594 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753817Ab0EWRYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 13:24:16 -0400
Date: Sun, 23 May 2010 10:24:13 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Henrik Rydberg" <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol
 (rev4)
Message-Id: <20100523102413.2fee3f4c.rdunlap@xenotime.net>
In-Reply-To: <1274567437-2818-2-git-send-email-rydberg@euromail.se>
References: <1274567437-2818-1-git-send-email-rydberg@euromail.se>
	<1274567437-2818-2-git-send-email-rydberg@euromail.se>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 May 2010 00:30:37 +0200 Henrik Rydberg wrote:

> This patch adds documentation for the ABS_MT_SLOT event and gives
> examples of how to use the event slot protocol.
> 
> Reviewed-by: Ping Cheng <pingc@wacom.com>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Revision 4 incorporates the following changes:
> 	 - Rename the slot event to ABS_MT_SLOT to keep all MT-related events
> 	   in the same namespace.
> 	 - Fix typo, thanks to Ping Cheng.
> 	   
>  Documentation/input/multi-touch-protocol.txt |  204 ++++++++++++++++++--------
>  1 files changed, 140 insertions(+), 64 deletions(-)
> 
> diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
> index c0fc1c7..92be65e 100644
> --- a/Documentation/input/multi-touch-protocol.txt
> +++ b/Documentation/input/multi-touch-protocol.txt
> @@ -6,31 +6,146 @@ Multi-touch (MT) Protocol
...
> +Protocol Usage
> +--------------
> +
> +Contact details are sent sequentially as separate packets of ABS_MT
> +events. Only the ABS_MT events are recognized as part of a contact
> +packet. Since these events are ignored by current single-touch (ST)
> +applications, the MT protocol can be implemented on top of the ST protocol
> +in an existing driver.
> +
> +Drivers for type A devices mark the end of a packet by calling the

end?

> +input_mt_sync() function, which generates a SYN_MT_REPORT event. This
> +instructs the receiver to accept the data for the current contact and
> +prepare to receive another. Drivers for type B devices mark the beginning

vs. beginning?  Seems incongruous.  And not just to the doc, but to
producers and consumers as well.


> +of a packet by calling the input_mt_slot() function with a slot as
> +argument, which generates an ABS_MT_SLOT event. This instructs the receiver
> +to prepare for updates of the given slot.
> +
> +The end of a multi-touch transfer is marked by calling the usual

The end method is done for Types A and B, right?


> +input_sync() function. This instructs the receiver to act upon events
> +accumulated since last EV_SYN/SYN_REPORT and prepare to receive a new set
> +of events/packets.
> +
...

> @@ -192,20 +277,11 @@ finger along the X axis (1).
>  Finger Tracking
>  ---------------
>  
> -The kernel driver should generate an arbitrary enumeration of the set of
> -anonymous contacts currently on the surface. The order in which the packets
> -appear in the event stream is not important.
> -
>  The process of finger tracking, i.e., to assign a unique trackingID to each
> -initiated contact on the surface, is left to user space; preferably the
> -multi-touch X driver [3]. In that driver, the trackingID stays the same and
> -unique until the contact vanishes (when the finger leaves the surface). The
> -problem of assigning a set of anonymous fingers to a set of identified
> -fingers is a euclidian bipartite matching problem at each event update, and
> -relies on a sufficiently rapid update rate.
> -
> -There are a few devices that support trackingID in hardware. User space can
> -make use of these native identifiers to reduce bandwidth and cpu usage.
> +initiated contact on the surface, is a Euclidian Bipartite Matching
> +problem.  At each event synchronization, the set of actual contacts are

                                                                       is

> +matched to the set of contacts from the previous synchronization. A full
> +implementation can be found in [3].


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
