Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab0EXFsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 01:48:38 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:58391 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab0EXFsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 01:48:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v6Ys83W5WfTDwzAU1cGO3T5A6lUBqkkBrHTzNUW/cRZ6oAT23FX64F0yxBYcT96rUV
         KxAlbKsMum3mhzCG4lvcnPNEFbdZULVpa1YqWvqO26h7frCvU1QNJr2mTA2G0e5o0Vd2
         UKsjExV20UTliFW/Wzaf7BvXpckQaoBtzw+Mw=
MIME-Version: 1.0
In-Reply-To: <20100524052530.GD16369@barra>
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se>
	 <1274213429-22667-2-git-send-email-rydberg@euromail.se>
	 <AANLkTikpmYwEYh5Dh-p3478cDMVo9hXOsDkt54ltHW6J@mail.gmail.com>
	 <4BF4E00A.30206@euromail.se>
	 <AANLkTinYX96zokFF6Rc-3_gxIrMZmvMS_pw3YdQD6CG4@mail.gmail.com>
	 <1274455140.1871.8.camel@tron>
	 <AANLkTimemw0iAslk6jeuwf0LGRgCo0-2Mvpgso42CP5Z@mail.gmail.com>
	 <4BF6FA55.6040900@euromail.se> <20100524052530.GD16369@barra>
Date: Sun, 23 May 2010 22:48:35 -0700
Message-ID: <AANLkTimoAPwV8IUox5MpOrFsefdte15dSCmNnuZ7bCOn@mail.gmail.com>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
From: Ping Cheng <pinglinux@gmail.com>
To: Peter Hutterer <peter.hutterer@who-t.net>
Cc: Henrik Rydberg <rydberg@euromail.se>, Rafi Rubin <rafi@seas.upenn.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Michael Poole <mdpoole@troilus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 23, 2010 at 10:25 PM, Peter Hutterer
<peter.hutterer@who-t.net> wrote:
> On Fri, May 21, 2010 at 11:25:41PM +0200, Henrik Rydberg wrote:
>> Ping Cheng wrote:
>> > On Fri, May 21, 2010 at 8:19 AM, Rafi Rubin <rafi@seas.upenn.edu> wrote:
>> [...]
>> >> Ping: please confirm, are you actually talking about each finger simultaneously sending multiple positions?
>> >
>> > You are definitely on the right track.  The fingers/touch objects can
>> > be represented two-dimensionally (x,y) instead of one-dimensionally
>> > (ABS_MT_TRACKING_ID).  I think we can survive with the current MT_BLOB
>> > definition although some optimization would be helpful, especially for
>> > filtering. For the sake of Henrik great effort, I'd like to see his
>> > current patchset gets in the tree before we start another round of
>> > "suggestions".
>> >
>> > Thank you for asking.
>>
>> Regarding blobs, I confused myself yesterday. The original intention of the blob
>>  id was in fact to be able to "paint" more generic contact forms. However, no
>> driver has come close to doing this yet, so it has gotten close to no attention.
>> Now, to address the question of how to communicate more elaborate contact forms,
>> it seems one can combine the two goals "one position per slot" and "multiple
>> positions per contact" by simply repeating the same tracking id for a set of
>> slots, like this:
>>
>> ABS_SLOT 0
>> ABS_MT_TRACKING_ID 14
>> ABS_MT_POSITION_X x[0]
>> ABS_MT_POSITION_Y y[0]
>> ABS_SLOT 1
>> ABS_MT_TRACKING_ID 14
>> ABS_MT_POSITION_X x[1]
>> ABS_MT_POSITION_Y y[1]
>> ABS_SLOT 2
>> ABS_MT_TRACKING_ID 14
>> ABS_MT_POSITION_X x[2]
>> ABS_MT_POSITION_Y y[2]
>>
>> Not all too different from what you suggested, and there is no blob id involved
>> at all. And yes, it would require additional parsing power at the user end.
>> Something for later.
>
> This is confusing me now :)
>
> How would a device get multiple x/y coordinates for a single contact? I
> could understand a range of coordinates but that's what we have the
> ABS_MT_WIDTH_MAJOR/MINOR for. If a touchpoint sends two different x/y
> coordinates, wouldn't that be two touchpoints, tracked individually and thus
> with a different tracking ID?
>
> I read the example above as _the_ example for using blob IDs to combine
> multiple contacts into one semantic contact.

As Henrik pointed out, the current BLOB format is for "more generic
contact forms", such as rectangles or ellipses.  They are special
blobs. A generic (true) blob doesn't have to have a regular shape.  It
is most likely in an irregular shape. They would be represented in an
array of points/contacts/(x,y)s,  whichever term works for you :).

tbh, I don't know what exact format we are going to use.  But, I feel
we can live with Henrik's current format, at least for a while.

Ping
