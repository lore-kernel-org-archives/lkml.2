Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab0EXF27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 01:28:59 -0400
Received: from leo.clearchain.com ([199.73.29.74]:60482 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab0EXF26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 01:28:58 -0400
Date: Mon, 24 May 2010 15:25:30 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Ping Cheng <pinglinux@gmail.com>, Rafi Rubin <rafi@seas.upenn.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
Message-ID: <20100524052530.GD16369@barra>
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se>
 <1274213429-22667-2-git-send-email-rydberg@euromail.se>
 <AANLkTikpmYwEYh5Dh-p3478cDMVo9hXOsDkt54ltHW6J@mail.gmail.com>
 <4BF4E00A.30206@euromail.se>
 <AANLkTinYX96zokFF6Rc-3_gxIrMZmvMS_pw3YdQD6CG4@mail.gmail.com>
 <1274455140.1871.8.camel@tron>
 <AANLkTimemw0iAslk6jeuwf0LGRgCo0-2Mvpgso42CP5Z@mail.gmail.com>
 <4BF6FA55.6040900@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF6FA55.6040900@euromail.se>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Mon, 24 May 2010 14:58:26 +0930 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 11:25:41PM +0200, Henrik Rydberg wrote:
> Ping Cheng wrote:
> > On Fri, May 21, 2010 at 8:19 AM, Rafi Rubin <rafi@seas.upenn.edu> wrote:
> [...]
> >> Ping: please confirm, are you actually talking about each finger simultaneously sending multiple positions?
> > 
> > You are definitely on the right track.  The fingers/touch objects can
> > be represented two-dimensionally (x,y) instead of one-dimensionally
> > (ABS_MT_TRACKING_ID).  I think we can survive with the current MT_BLOB
> > definition although some optimization would be helpful, especially for
> > filtering. For the sake of Henrik great effort, I'd like to see his
> > current patchset gets in the tree before we start another round of
> > "suggestions".
> > 
> > Thank you for asking.
> 
> Regarding blobs, I confused myself yesterday. The original intention of the blob
>  id was in fact to be able to "paint" more generic contact forms. However, no
> driver has come close to doing this yet, so it has gotten close to no attention.
> Now, to address the question of how to communicate more elaborate contact forms,
> it seems one can combine the two goals "one position per slot" and "multiple
> positions per contact" by simply repeating the same tracking id for a set of
> slots, like this:
> 
> ABS_SLOT 0
> ABS_MT_TRACKING_ID 14
> ABS_MT_POSITION_X x[0]
> ABS_MT_POSITION_Y y[0]
> ABS_SLOT 1
> ABS_MT_TRACKING_ID 14
> ABS_MT_POSITION_X x[1]
> ABS_MT_POSITION_Y y[1]
> ABS_SLOT 2
> ABS_MT_TRACKING_ID 14
> ABS_MT_POSITION_X x[2]
> ABS_MT_POSITION_Y y[2]
> 
> Not all too different from what you suggested, and there is no blob id involved
> at all. And yes, it would require additional parsing power at the user end.
> Something for later.

This is confusing me now :)

How would a device get multiple x/y coordinates for a single contact? I
could understand a range of coordinates but that's what we have the
ABS_MT_WIDTH_MAJOR/MINOR for. If a touchpoint sends two different x/y
coordinates, wouldn't that be two touchpoints, tracked individually and thus
with a different tracking ID?

I read the example above as _the_ example for using blob IDs to combine
multiple contacts into one semantic contact.

Cheers,
  Peter
