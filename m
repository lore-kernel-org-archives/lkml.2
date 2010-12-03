Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab0LCNxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 08:53:06 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:36113 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754683Ab0LCNxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 08:53:04 -0500
Subject: Re: [RFC v6 2/9] Documentation:DocBook:v4l: Update the
 controls.xml for TI FM driver
From: Andy Walls <awalls@md.metrocast.net>
To: manjunatha_halli@ti.com
Cc: mchehab@infradead.org, hverkuil@xs4all.nl, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
In-Reply-To: <1291380631-25993-3-git-send-email-manjunatha_halli@ti.com>
References: <1291380631-25993-1-git-send-email-manjunatha_halli@ti.com>
	 <1291380631-25993-2-git-send-email-manjunatha_halli@ti.com>
	 <1291380631-25993-3-git-send-email-manjunatha_halli@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Dec 2010 08:53:27 -0500
Message-ID: <1291384407.2800.77.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-12-03_09:2010-12-03,2010-12-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=1
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1010190000 definitions=main-1012030043
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Em 03-12-2010 10:50, manjunatha_halli@ti.com escreveu:
> > From: Manjunatha Halli <manjunatha_halli@ti.com>
> > 
> > Added entries for following 2 new CID's which are added for TI FM
> > driver:
> > - V4L2_CID_RSSI_THRESHOLD
> > - V4L2_CID_TUNE_AF
> > 
> > Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
> > ---
> >  Documentation/DocBook/v4l/controls.xml |   12 ++++++++++++
> >  1 files changed, 12 insertions(+), 0 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/v4l/controls.xml b/Documentation/DocBook/v4l/controls.xml
> > index 2fae3e8..b560953 100644
> > --- a/Documentation/DocBook/v4l/controls.xml
> > +++ b/Documentation/DocBook/v4l/controls.xml
> > @@ -132,6 +132,18 @@ consumption state.</entry>
> >  	    <entry>Loudness mode (bass boost).</entry>
> >  	  </row>
> >  	  <row>
> > +           <entry><constant>V4L2_CID_RSSI_THRESHOLD</constant></entry>
> > +           <entry>integer</entry>
> > +           <entry>Set RSSI threshold level. Change the default threshold
> > +level used to select valid frequencies during vidioc_s_hw_freq_seek.</entry>
> > +         </row>
> > +         <row>
> > +           <entry><constant>V4L2_CID_TUNE_AF</constant></entry>
> > +           <entry>integer</entry>
> > +           <entry>Set Alternative Frequency mode. Enable or disable
> > +alternative frequency mode.</entry>
> > +         </row>
> > +         <row>
> >  	    <entry><constant>V4L2_CID_BLACK_LEVEL</constant></entry>
> >  	    <entry>integer</entry>
> >  	    <entry>Another name for brightness (not a synonym of
> 
> Sorry, but, I doubt that any userspace application developer will find those descriptions
> useful. 
> 
> For the threshold: I understand that this is the carrier strength used to detect a
> channel, right? If so, please improve the description.
> Also, The better is to associate its scale to a carrier level in some unit like dB.

Hi Mauro and Manjunatha,

>From my recollection of 3GPP (which is obviously not FM radio), the
requirements on a RSSI are intentionally loose.  The "I" in RSSI is for
"indicator", not a precise quantity.  An example RSSI measurement
specification can be found here:

ftp://ftp.3gpp.org/specs/2010-09/Rel-9/25_series/25215-920.zip
(I couldn't find an RSSI spec for FM radio.)

In 3GPP, RSSI is used for Human-Machine interfaces: e.g. How many bars
are shown on your phone's display.  Applications can also use it to
decide if they have sufficient signal or not.

I don't think standardizing the units into dB is going to be useful for
applications.  RSSI measurements from different FM receiver hardware
cannot be fairly compared using standard units, since not all FM
receivers will be creating a RSSI value in the same way.

However, standardizing the range of the scale for this control would be
useful for applications.  I don't care if drivers use a scale of 0-100,
0-255 (like this patchset), or 0-65535.  I just suggest that all
drivers, that provide this process-decision threshold-control, use the
same range.

My $0.02.


> The second control means absolutely nothing... It is not a boolean value, and what
> is "alternative" frequency mode?

I agree with Mauro here.  The documentation does not give any idea what
alternate frequency means to an application developer who does not
already know about the underlying hardware receiver.

Regards,
Andy


