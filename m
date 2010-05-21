Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab0EUV16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 17:27:58 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:52040 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751394Ab0EUV14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 17:27:56 -0400
Message-ID: <4BF6FA55.6040900@euromail.se>
Date: Fri, 21 May 2010 23:25:41 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Ping Cheng <pinglinux@gmail.com>
CC: Rafi Rubin <rafi@seas.upenn.edu>, Henrik Rydberg <rydberg@euromail.se>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se>	 <1274213429-22667-2-git-send-email-rydberg@euromail.se>	 <AANLkTikpmYwEYh5Dh-p3478cDMVo9hXOsDkt54ltHW6J@mail.gmail.com>	 <4BF4E00A.30206@euromail.se>	 <AANLkTinYX96zokFF6Rc-3_gxIrMZmvMS_pw3YdQD6CG4@mail.gmail.com>	 <1274455140.1871.8.camel@tron> <AANLkTimemw0iAslk6jeuwf0LGRgCo0-2Mvpgso42CP5Z@mail.gmail.com>
In-Reply-To: <AANLkTimemw0iAslk6jeuwf0LGRgCo0-2Mvpgso42CP5Z@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OFZj1-0007uM-3w.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1OFZj1-0007uM-3w 88e1fc3a3d21b91373b9c43ab21d5851
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping Cheng wrote:
> On Fri, May 21, 2010 at 8:19 AM, Rafi Rubin <rafi@seas.upenn.edu> wrote:
[...]
>> Ping: please confirm, are you actually talking about each finger simultaneously sending multiple positions?
> 
> You are definitely on the right track.  The fingers/touch objects can
> be represented two-dimensionally (x,y) instead of one-dimensionally
> (ABS_MT_TRACKING_ID).  I think we can survive with the current MT_BLOB
> definition although some optimization would be helpful, especially for
> filtering. For the sake of Henrik great effort, I'd like to see his
> current patchset gets in the tree before we start another round of
> "suggestions".
> 
> Thank you for asking.

Regarding blobs, I confused myself yesterday. The original intention of the blob
 id was in fact to be able to "paint" more generic contact forms. However, no
driver has come close to doing this yet, so it has gotten close to no attention.
Now, to address the question of how to communicate more elaborate contact forms,
it seems one can combine the two goals "one position per slot" and "multiple
positions per contact" by simply repeating the same tracking id for a set of
slots, like this:

ABS_SLOT 0
ABS_MT_TRACKING_ID 14
ABS_MT_POSITION_X x[0]
ABS_MT_POSITION_Y y[0]
ABS_SLOT 1
ABS_MT_TRACKING_ID 14
ABS_MT_POSITION_X x[1]
ABS_MT_POSITION_Y y[1]
ABS_SLOT 2
ABS_MT_TRACKING_ID 14
ABS_MT_POSITION_X x[2]
ABS_MT_POSITION_Y y[2]

Not all too different from what you suggested, and there is no blob id involved
at all. And yes, it would require additional parsing power at the user end.
Something for later.

Cheers,
Henrik
