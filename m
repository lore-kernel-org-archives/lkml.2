Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934293Ab1CZCMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 22:12:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55520 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229Ab1CZCMB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 22:12:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=QS47G57n0bU7kAMrUo1D5h8QJeaV6HHlVqXMD3Kz2INyYvDWhIPlFs24GdTpFvet6K
         IJuhFPq5DSiBxhKWcRjJywy9RGvoFf6s9adyYF3bQ3sJuTuKF4AQVWDPjCVg1S2quR+U
         KkcEqQz4upi/4nr1FH+5oHyLcvKMrWktgFSj4=
MIME-Version: 1.0
In-Reply-To: <20110326001143.GX3130@pulham.picochip.com>
References: <1301073283-30821-1-git-send-email-jamie@jamieiles.com>
 <1301073283-30821-4-git-send-email-jamie@jamieiles.com> <AANLkTin+Uvw8=CN+2oawAUHGot8gdM5u98S4zC8QoB=u@mail.gmail.com>
 <20110326001143.GX3130@pulham.picochip.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 25 Mar 2011 22:11:40 -0400
X-Google-Sender-Auth: 1vdbuJbOAPCRw1myC_lTCv9cPPc
Message-ID: <AANLkTimfjaviwQg5XD9HwtXMOPXq_=N_WOwpQyPf4L_9@mail.gmail.com>
Subject: Re: [RFC PATCHv3 3/4] drivers/otp: convert bfin otp to generic OTP
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 20:11, Jamie Iles wrote:
> or shall I just leave it as one big region for now?

for now, stick with one region.  i can refine it later if i desire.

>> > +static const struct otp_region_ops bfin_region_ops = {
>> > +       .read_word      = bfin_region_read_word,
>> > +       .write_word     = bfin_region_write_word,
>> > +       .get_size       = bfin_region_get_size,
>> > +       .get_fmt        = bfin_region_get_fmt,
>> > +       .ioctl          = bfin_region_ioctl,
>> > +};
>>
>> hmm, i just realized this stuff is per-region.  wouldnt the
>> read/write/ioctl make more sense as per-device ?
>
> No, I don't think so.  The file_operations are all based on the regions
> rather than the device so I think it makes sense to have these as region
> based operations.  We could make them per device and pass the region as
> a parameter but I'm not sure that it gains us anything.

for a device that exports more than one region, you dont need to
duplicate the structure.  as you add in more regions, the amount of
duplication increases.

how many regions does your device export ?  does it need different
read/write behavior for each ?
-mike
