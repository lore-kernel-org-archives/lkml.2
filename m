Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab2HCQJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:09:25 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:8029 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab2HCQJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:09:24 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=rZgOsxURPmfOTd5dzXsESsTEEOIZyuLG+jkDuL38uDow9PeYa/0u2vwUkg8K
	oFmkFmd5YIzuoKrD63t24QKr4HKzhUHwvyqnJ+q8A9UC/XWYLmaiZ+ftB
	YOfLNPzsDVhu1CjjQAAmV48jHQIfkuOd1UNJuJJ2EQH+J3wrMRl7+s=;
X-Spam-Processed: mail.digidescorp.com, Fri, 03 Aug 2012 11:09:22 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1562e4c178=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1344010161.2474.4.camel@iscandar.digidescorp.com>
Subject: Re: [PATCH] fat: Refactor shortname parsing
From: "Steven J. Magnani" <steve@digidescorp.com>
To: Jan Engelhardt <jengelh@inai.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org
Date: Fri, 03 Aug 2012 11:09:21 -0500
In-Reply-To: <alpine.LNX.2.01.1208031734550.7170@frira.zrqbmnf.qr>
References: <1341314074-2867-1-git-send-email-steve@digidescorp.com>
	 <alpine.LNX.2.01.1208031650580.3676@frira.zrqbmnf.qr>
	 <87lihw10cs.fsf@devron.myhome.or.jp>
	 <alpine.LNX.2.01.1208031734550.7170@frira.zrqbmnf.qr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-03 at 17:58 +0200, Jan Engelhardt wrote: 
> On Friday 2012-08-03 17:06, OGAWA Hirofumi wrote:
> >>>+static inline unsigned char fat_tolower(unsigned char c)
> >>>+{
> >>>+	return ((c >= 'A') && (c <= 'Z')) ? c+32 : c;
> >>>+}
> >>>+
> >>
> >> The kernel already has a tolower() function, can that not be used?
> >
> >tolower() is not exactly same, right? e.g. tolower(0xc0). Otherwise,
> >tolower() is fine.
> 
> Yes, but you can still
> 
> 	return (c >= 'A' && c <= 'Z') ? tolower(c) : c;

But now it's less efficient because tolower() does an unnecessary lookup
to see if it's supposed to change the value. _tolower() wouldn't have
that issue, but it's marked "Do not use in your code". 

------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer>


