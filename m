Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab0IJJbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:31:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57891 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab0IJJbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:31:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iURrJoL6MVfRm5Dyo7fhtEtGBmBjLmyJlrzS+Jn8zfK9Lhe7TKyagBtLugJ5gqjufI
         8TiuXrBhEHXOmc1INd2ZmZFUn4+dYCv6LpHYsIBizSJoioQpO5wmVMu691WArL62T8aQ
         NFQIA1Cwr7StAftBK0CKaOKoirYMYwvLAQ0A8=
Date: Fri, 10 Sep 2010 11:31:35 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH 2/2] posix clocks: introduce a sysfs presence.
Message-ID: <20100910093135.GB10179@riccoc20.at.omicron.at>
References: <cover.1283504065.git.richard.cochran@omicron.at>
 <84124d2479b8967cac2b35f852fc0fcae6ad9444.1283504065.git.richard.cochran@omicron.at>
 <20100910000008.1483fdd7@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100910000008.1483fdd7@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 12:00:08AM +0100, Alan Cox wrote:
> Also we have existing time sources that don't follow the poxix clock
> model - I can open /dev/rtc and I can open the hpet and so on.
> 
> I like /sys/class/time* *but* you need to be able to open the sysfs
> device and apply operations to it in order for it to work when your closk
> can be dynamically created and destroyed and to get a sane Unix API.
> 
> To start with try applying permissions to clock sources via the POSIX
> API. That is something that will be required for some applications.
> 
> I need to be able to open sys/clock/foo/something and get a meaningful
> handle. Sure it's quite likely the operations it supports are related to
> the POSIX timer ops.

Do you mean this:

   id = read(/sys/clock/foo/lock); /* clock is busy, cannot be removed */
   ...
   clock_gettime(id, ts);
   ...
   write(/sys/clock/foo/release, id); /* all done with clock */

I am not sure what you are describing. Can you give an example, like
pseudocode or something?

Thanks,
Richard
