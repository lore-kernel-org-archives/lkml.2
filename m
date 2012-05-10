Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab2EJMl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 08:41:29 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:59657 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab2EJMl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 08:41:26 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsKfAH62q09V5qg+PGdsb2JhbABEijioLwMBgR0ZAQEBAR4ZDSeCFQEBBAEnExwjEAgDRhQlChqIHAm7PROLQoF5gwpjBJV8hgWDVIlT
X-IronPort-AV: E=Sophos;i="4.75,565,1330902000"; 
   d="scan'208";a="330881713"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 10 May 2012 14:46:42 +0200
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] HID: hid-multitouch: get maxcontacts also from
 logical_max value
Message-ID: <20120510124642.GA9254@polaris.bitmath.org>
References: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
 <1336136030-18503-3-git-send-email-benjamin.tissoires@gmail.com>
 <20120506190322.GB12571@polaris.bitmath.org>
 <CAN+gG=HQ_U5dhVvgLu0zfMjv1+SAVB2Rx8fNq8tLX2DUHOMa9A@mail.gmail.com>
 <20120509194623.GA12381@polaris.bitmath.org>
 <CAN+gG=Fyq7S54rkDRsUmEytxcU-HQb68qENnED8=xaUxF3-BXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=Fyq7S54rkDRsUmEytxcU-HQb68qENnED8=xaUxF3-BXQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > As long as all existing devices are unaffected, it's fine, hence the question.
> 
> I checked all the reports descriptors that I have.
> 2 devices (one Stantum and one Irtouch) present an unrealistic
> logical_max value (255). The thing is that if this logical_max is
> false, and if the value is not provided, then I don't know how could I
> retrieve the right value beside introducing a MT_CLS...
> 
> Henrik, do you think that 255 is two much for the slots?

It is large enough for us to start worrying about how we manage
memory, not to mention throughput. Since we do not really have devices
of that type yet, how about adding a MT_MAX_MAXCONTACT next to
MT_DEFAULT_MAXCONTACT, and use it as a sanity check, like so:

	if (!td->maxcontacts && field->logical_maximum <= MT_MAX_MAXCONTACT)
		td->maxcontacts = field->logical_maximum;

Then the default (10) would be picked for the suspect devices, just as
it is today.

Thanks,
Henrik
