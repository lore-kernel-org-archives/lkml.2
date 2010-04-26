Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab0DZWGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 18:06:48 -0400
Received: from web94916.mail.in2.yahoo.com ([203.104.17.196]:29422 "HELO
	web94916.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752894Ab0DZWGr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 18:06:47 -0400
Message-ID: <867722.38404.qm@web94916.mail.in2.yahoo.com>
X-YMail-OSG: LaorrgMVM1k2j8IpJ48Tj2qSF1tsvcxLupBFq3qZv7HybzE
 bVR8Eu_uQ0upCZBOV7FIG048Dh86uB8ESmdaF3pfd7ZrO7mQas.egSSVln9W
 BTQo3mzgiciFH9ui37HSArF5ole5pahkDPv3fBtm0BqK7ctkECHSFFciGXGs
 vAiA7S21UMZiVVkm5JukdeSZu54YA9CBY_0Pbsm6Gqu5LAG.XCWtxh1B3J5d
 s5n2c3L9myf_zCKVwmL.vqn20HliciYIDCviyknG9lPwksVUD4eurf7rOZE6
 hZMYYiAA0bJMjQdsw
X-RocketYMMF: pavan_savoy
X-Mailer: YahooMailClassic/10.1.9 YahooMailWebService/0.8.100.260964
Date: Tue, 27 Apr 2010 03:36:43 +0530 (IST)
From: Pavan Savoy <pavan_savoy@ti.com>
Reply-To: pavan_savoy@ti.com
Subject: Re: [PATCH] drivers:staging: sources for ST core
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, npelly@google.com
In-Reply-To: <20100426230352.1564ef0f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

--- On Tue, 27/4/10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Subject: Re: [PATCH] drivers:staging: sources for ST core
> To: pavan_savoy@ti.com
> Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, npelly@google.com, pavan_savoy@yahoo.co.in
> Date: Tuesday, 27 April, 2010, 3:33 AM
> 
> > +/* function pointer pointing to either,
> > + * st_kim_recv during registration to receive fw
> download responses
> > + * st_int_recv after registration to receive proto
> stack responses
> > + */
> > +void (*st_recv) (void*, const unsigned char*, long);
> 
> You still need a context of some kind as I said before to
> avoid thse
> globals and single device limits.

The st_recv is a global pointer to a function, and changes only once in lifetime of the driver (after a function called download_firmware).
This can be easily avoided by having a flag in my st_tty_recieve function, as in

if (test_bit(FIRMWARE_DOWNLOADED, st_gdata->st_state)
        /*
         * if fw download is in progress then route incoming data
         * to KIM for validation
         */
        st_int_recv(data, count);
else
        kim_recv(data, count);
        ST_DRV_VER("done %s", __func__);

However, the other global reference which was st_gdata, now is inside the tty->disc_data reference.

Should I put in the above ?

> And all the other issues - no explanation of the locking
> etc don't seem
> to have been touched either.

I have removed most un-wanted locking stuff, I could find.
What else is required ? please suggest.

> I don't really see how I am supposed to review this stuff
> when the
> locking and flow control assumptions are completely opaque

Didn't get what is that is required about flow-control ?
> Alan
> 

Send free SMS to your Friends on Mobile from your Yahoo! Messenger. Download Now! http://messenger.yahoo.com/download.php
