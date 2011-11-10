Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933996Ab1KJIHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:07:37 -0500
Received: from emcscan.emc.com.tw ([192.72.220.5]:51760 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933946Ab1KJIHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:07:34 -0500
From: JJ Ding <jj_ding@emc.com.tw>
To: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        JJ Ding <dgdunix@gmail.com>
Subject: Re: [PATCH v3] Input: convert obsolete strict_strtox to kstrtox
In-Reply-To: <CAM=Q2csTJeZnjcDCm+hmTn9q4_RhU=-2Mnfu84eeOdVESZmo4w@mail.gmail.com>
References: <1320827729-11394-1-git-send-email-jj_ding@emc.com.tw> <CAM=Q2csTJeZnjcDCm+hmTn9q4_RhU=-2Mnfu84eeOdVESZmo4w@mail.gmail.com>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 10 Nov 2011 16:05:13 +0800
Message-ID: <87vcqs7686.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shubhrajyoti,

[Your mail has HTML part so I think it was blocked by Lists]

On Wed, 9 Nov 2011 14:32:12 +0530, Shubhrajyoti Datta <omaplinuxkernel@gmail.com> wrote:
> Hello ,
> Some doubts .
> 
> On Wed, Nov 9, 2011 at 2:05 PM, JJ Ding <jj_ding@emc.com.tw> wrote:
> 
> > @@ -1313,7 +1313,11 @@ static ssize_t atkbd_set_extra(struct atkbd *atkbd,
> > const char *buf, size_t coun
> >        if (!atkbd->write)
> >                return -EIO;
> >
> > -       if (strict_strtoul(buf, 10, &value) || value > 1)
> > +       err = kstrtouint(buf, 10, &value);
> > +       if (err)
> > +               return err;
> > +
> > +       if (value > 1)
> >                return -EINVAL;
> >
> 
> Is the intention here to have bool ?
> 
> >
> >        if (atkbd->extra != value) {
> > @@ -1389,11 +1393,15 @@ static ssize_t atkbd_show_scroll(struct atkbd
> > *atkbd, char *buf)
> >  static ssize_t atkbd_set_scroll(struct atkbd *atkbd, const char *buf,
> > size_t count)
> >  {
> >        struct input_dev *old_dev, *new_dev;
> > -       unsigned long value;
> > +       unsigned int value;
> >        int err;
> >        bool old_scroll;
> >
> > -       if (strict_strtoul(buf, 10, &value) || value > 1)
> > +       err = kstrtouint(buf, 10, &value);
> > +       if (err)
> > +               return err;
> > +
> > +       if (value > 1)
> >                return -EINVAL;
> >
> 
> Same here ?
> 
> 
> >
> >        if (atkbd->scroll != value) {
> > @@ -1433,7 +1441,7 @@ static ssize_t atkbd_show_set(struct atkbd *atkbd,
> > char *buf)
> >  static ssize_t atkbd_set_set(struct atkbd *atkbd, const char *buf, size_t
> > count)
> >  {
> >        struct input_dev *old_dev, *new_dev;
> > -       unsigned long value;
> > +       unsigned int value;
> >        int err;
> >        unsigned char old_set;
> >        bool old_extra;
> > @@ -1441,7 +1449,11 @@ static ssize_t atkbd_set_set(struct atkbd *atkbd,
> > const char *buf, size_t count)
> >        if (!atkbd->write)
> >                return -EIO;
> >
> > -       if (strict_strtoul(buf, 10, &value) || (value != 2 && value != 3))
> > +       err = kstrtouint(buf, 10, &value);
> > +       if (err)
> > +               return err;
> > +
> > +       if (value != 2 && value != 3)
> >                return -EINVAL;
> >
> 
> Will u8 be sufficient ?
> 

Dmitry suggested we stick with int. please see:
  https://lkml.org/lkml/2011/11/8/328
for our previous discussions.

Thanks,
jj
