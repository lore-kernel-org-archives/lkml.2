Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab2AaNqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:46:09 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:56337 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237Ab2AaNqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:46:07 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [PATCH 05/16] cx18: fix handling of 'radio' module parameter
Date: Tue, 31 Jan 2012 14:45:18 +0100
User-Agent: KMail/1.9.10
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, ivtv-devel@ivtvdriver.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, mchehab@redhat.com
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de> <1327960820-11867-6-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1327960820-11867-6-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201311445.20095.danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328017567;6b7c41b3;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dienstag, 31. Januar 2012, Andy Walls wrote:
> On Tue, 2012-01-31 at 05:01 -0500, Andy Walls wrote:
> > On Mon, 2012-01-30 at 20:40 +0100, Danny Kukawka wrote:
> > > Fixed handling of 'radio' module parameter from module_param_array
> > > to module_param_named to fix these compiler warnings in cx18-driver.c:
> >
> > NACK.
> >
> > "radio" is an array of tristate values (-1, 0, 1) per installed card:
> >
> > 	static int radio[CX18_MAX_CARDS] = { -1, -1,
> >
> > and must remain an array or you will break the driver.
> >
> > Calling "radio_c" a module parameter named "radio" is wrong.
> >
> > The correct fix is to reverse Rusty Russel's patch to the driver in
> > commit  90ab5ee94171b3e28de6bb42ee30b527014e0be7
> > to change the "bool" back to an "int" as it should be in
>
>                       ^^^^
> Sorry, a typo here.  Disregard the word "back".

Overseen this. But wouldn't be the correct fix in this case to:
a) reverse the part of 90ab5ee94171b3e28de6bb42ee30b527014e0be7 to:
   get: 
   static unsigned radio_c = 1;
   
b) change the following line:
   module_param_array(radio, bool, &radio_c, 0644);
   to:
   module_param_array(radio, int, &radio_c, 0644);

Without b) you would get a warning from the compiler again.

Danny 
