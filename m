Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab2HNTyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 15:54:14 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:61050 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab2HNTyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 15:54:12 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ping Cheng <pinglinux@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/19] Input: Improve the events-per-packet estimate
Date: Tue, 14 Aug 2012 12:53:56 -0700
Message-ID: <2226930.JeU38gc4Sp@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.8.4 (Linux/3.5.0-2.fc17.x86_64; KDE/4.8.4; x86_64; ; )
In-Reply-To: <CAF8JNhJzu9wW52PbydVuH9y8TwOs=mPO0DJn0aJBpsh-wETzuQ@mail.gmail.com>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se> <1344807757-2217-3-git-send-email-rydberg@euromail.se> <CAF8JNhJzu9wW52PbydVuH9y8TwOs=mPO0DJn0aJBpsh-wETzuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 14, 2012 12:32:21 PM Ping Cheng wrote:
> On Sun, Aug 12, 2012 at 2:42 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> > Many MT devices send a number of keys along with the mt information.
> > This patch makes sure that there is room for them in the packet
> > buffer.
> > 
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> > ---
> > 
> >  drivers/input/input.c | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/input/input.c b/drivers/input/input.c
> > index 6e90705..8ebf116 100644
> > --- a/drivers/input/input.c
> > +++ b/drivers/input/input.c
> > @@ -1777,6 +1777,9 @@ static unsigned int
> > input_estimate_events_per_packet(struct input_dev *dev)> 
> >                 if (test_bit(i, dev->relbit))
> >                 
> >                         events++;
> > 
> > +       /* Make room for KEY and MSC events */
> > +       events += 7;
> 
> Hi Henrik,
> 
> It is nice to get rid of the redundant pieces and to incorporate
> common functions. Thank you.
> 
> I have a question about the code above though.  Why do we use 7
> instead of going through the keys like:
> 
> 	for (i = 0; i < KEY_MAX; i++)
> 		if (test_bit(i, dev->keybit))
> 			events++;

Because that would result in gross over-estimation for many devices - 
my keyboard has 100+ keys but it never sends all of them in one event
frame, not even if I can get a cat to lay on it ;)

-- 
Dmitry

