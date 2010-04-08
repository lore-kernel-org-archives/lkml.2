Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728Ab0DHOXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 10:23:15 -0400
Received: from mx4.sophos.com ([74.202.89.161]:50880 "EHLO mx4.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235Ab0DHOXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 10:23:09 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Apr 2010 10:23:09 EDT
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] loop: Update mtime when writing using aops
Date: Thu, 8 Apr 2010 15:15:55 +0100
User-Agent: KMail/1.9.10
CC: Nikanth Karthikesan <knikanth@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201004081551.37824.knikanth@suse.de> <20100408124539.GM10103@kernel.dk>
In-Reply-To: <20100408124539.GM10103@kernel.dk>
MIME-Version: 1.0
Message-ID: <201004081515.56161.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 08/04/2010 15:15:56,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 08/04/2010 15:15:57,
	Serialize complete at 08/04/2010 15:15:57
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 April 2010 13:45:39 Jens Axboe wrote:
> On Thu, Apr 08 2010, Nikanth Karthikesan wrote:
> > Update mtime when writing to backing filesystem using the address space
> > operations write_begin and write_end.
>
> You forgot to include a 'why' :-)
>
> Not that I disagree with the patch, just curious what made you make the
> change.

You mean how the bug was found? I originally reported this problem against
openSUSE 11.2 kernel, where when you have a dm-crypt loop filesystem the
container file modification time does not get updated with use. Consequence
of that is that backup runs would miss the fact container has changed.

Maybe one could argue it is a security feature in this scenario :), but as the
problem turns out to be unrelated to the crypto case, rather contained in the
loop driver itself, it looks like that would not hold.

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
