Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935806Ab0EVDKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 23:10:34 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:65013 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933564Ab0EVDKa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 23:10:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z1cGNxYdNiqx+NqdL67JzXskIG0s2JqjxAlHvIZBfTqEsfjDHK03IedrTDzncUlLJt
         KG+TGKih+Tuek4zVZG89ujbHW3rnYQNS2aGbk8gJwetqwnTPhyC+FIclYvPwo91b2Fwg
         d9NUdKMW86mrxL0XMDo5RMgNee1Rw8QLMX1Ro=
MIME-Version: 1.0
In-Reply-To: <4BF6FA55.6040900@euromail.se>
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se>
	 <1274213429-22667-2-git-send-email-rydberg@euromail.se>
	 <AANLkTikpmYwEYh5Dh-p3478cDMVo9hXOsDkt54ltHW6J@mail.gmail.com>
	 <4BF4E00A.30206@euromail.se>
	 <AANLkTinYX96zokFF6Rc-3_gxIrMZmvMS_pw3YdQD6CG4@mail.gmail.com>
	 <1274455140.1871.8.camel@tron>
	 <AANLkTimemw0iAslk6jeuwf0LGRgCo0-2Mvpgso42CP5Z@mail.gmail.com>
	 <4BF6FA55.6040900@euromail.se>
Date: Fri, 21 May 2010 20:10:29 -0700
Message-ID: <AANLkTik9LlaAk-6dB2_Vy4_rESGYx7VKSRBxeBOPP87W@mail.gmail.com>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Rafi Rubin <rafi@seas.upenn.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Michael Poole <mdpoole@troilus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 2:25 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Ping Cheng wrote:
>> On Fri, May 21, 2010 at 8:19 AM, Rafi Rubin <rafi@seas.upenn.edu> wrote:
> [...]
>>> Ping: please confirm, are you actually talking about each finger simultaneously sending multiple positions?
>>
>> You are definitely on the right track.  The fingers/touch objects can
>> be represented two-dimensionally (x,y) instead of one-dimensionally
>> (ABS_MT_TRACKING_ID).  I think we can survive with the current MT_BLOB
>> definition although some optimization would be helpful, especially for
>> filtering. For the sake of Henrik great effort, I'd like to see his
>> current patchset gets in the tree before we start another round of
>> "suggestions".
>>
>> Thank you for asking.
>
> Regarding blobs, I confused myself yesterday. The original intention of the blob
>  id was in fact to be able to "paint" more generic contact forms. However, no
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

This solution matches with my imagination more closely.  Let's stay
with it for now.  I may come up with other suggestions once I have
time to do real testing with the protocol.

Thank you, Henrik, for your continuous effort.

Ping
