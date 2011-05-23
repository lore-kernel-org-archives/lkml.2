Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1EWHJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 03:09:50 -0400
Received: from ams-iport-2.cisco.com ([144.254.224.141]:41882 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab1EWHJt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 03:09:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgIEAAUH2k2Q/khMgWdsb2JhbACmIRQBARYmJohwnHycXYYZBJRJij8
X-IronPort-AV: E=Sophos;i="4.65,255,1304294400"; 
   d="scan'208";a="31720207"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [lm-sensors] [PATCH] Add support for the Philips SA56004 temperature sensor.
Date: Mon, 23 May 2011 09:08:42 +0200
Message-ID: <6E4D2678AC543844917CA081C9D6B33F047F51E5@XMB-AMS-103.cisco.com>
In-Reply-To: <20110523043711.GA4890@ericsson.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [lm-sensors] [PATCH] Add support for the Philips SA56004 temperature sensor.
Thread-Index: AcwZAx/ILp0IwrjMSl+rRM/za61iNAAFMu0A
References: <1305814253-12528-1-git-send-email-sdevrien@cisco.com> <20110523043711.GA4890@ericsson.com>
From: "Stijn Devriendt (sdevrien)" <sdevrien@cisco.com>
To: "Guenter Roeck" <guenter.roeck@ericsson.com>
Cc: <khali@linux-fr.org>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 23 May 2011 07:09:47.0475 (UTC) FILETIME=[6665AA30:01CC1918]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Guenter Roeck [mailto:guenter.roeck@ericsson.com]
> 
> >  	if (!name) { /* identification failed */
> > @@ -1372,6 +1401,18 @@ static int lm90_probe(struct i2c_client
> *new_client,
> >  	/* Set maximum conversion rate */
> >  	data->max_convrate = lm90_params[data->kind].max_convrate;
> >
> > +	if (data->flags & LM90_HAVE_LOCAL_EXT) {
> > +		if (lm90_params[data->kind].local_ext_offset > 0)
> > +			data->local_ext_offset =
> > +
lm90_params[data->kind].local_ext_offset;
> > +		else {
> > +			dev_err(&new_client->dev,
> > +			  "Invalid temperature extension register. "
> > +			  "Accuracy may be limited.\n");
> > +			data->flags &= (~LM90_HAVE_LOCAL_EXT);
> > +		}
> 
> Either { } in both branches of the if statement, or none.
> ( ) around ~LM90_HAVE_LOCAL_EXT is unnecessary.
> 
> I see it as BUG if LM90_HAVE_LOCAL_EXT is set but local_ext_offset
isn't.
> That should be found during coding (or code review), and not be
exported
> to the user. So, from my perspective, the check is unnecessary. I'll
leave
> that up to Jean to decide, though.
> 
Do you think a BUG_ON() would be better suited here?

> In addition to the above, your patch generates several checkpatch
errors
> (trailing whitespace). Please fix.
I recall letting checkpatch yell at me... I'll have another round of it
to
be sure.

Thanks,
Stijn
