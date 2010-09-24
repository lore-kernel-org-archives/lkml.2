Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab0IXNOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:14:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33795 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab0IXNOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:14:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V4Rux4oKDcMPKTU0Ks0061Zt4absOfOZ4Lqrm5VEmxSzTlCNlav/Mt6ZncERDxRHk6
         aIe5SPtIl4iwdMUu2LE+O9JUf5n5AJB739aeBQnNrThvGns/OsCQS6V8R2UecYaFFxEL
         4mhAIKpXGgNSoX4qKQwkLGqnMGP2bMeyQ7HjQ=
Date: Fri, 24 Sep 2010 15:14:07 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v6 0/8] ptp: IEEE 1588 hardware clock support
Message-ID: <20100924131407.GA3113@riccoc20.at.omicron.at>
References: <cover.1285261533.git.richard.cochran@omicron.at>
 <20100923213654.0c64b047@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100923213654.0c64b047@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 09:36:54PM +0100, Alan Cox wrote:
> Drop the clockid_t and swap it for a file handle like a proper Unix or
> Linux interface. The rest is much the same
> 
> 	fd = open /sys/class/timesource/[whatever]
> 
> 	various queries you may want to do to check the name etc
> 
> 	fclock_adjtime(fd, ...)

Okay, but lets extend the story:

	clock_getttime(fd, ...);

	clock_settime(fd, ...);

	timer_create(fd, ...);

Can you agree to that as well?

(We would need to ensure that 'fd' avoids the range 0 to MAX_CLOCKS).

Richard
